import QtQuick
import QtQuick.Controls

import MMaterial.UI as UI
import MMaterial.Controls as Controls
import MMaterial.Controls.Inputs as Inputs

Inputs.ComboBox {
	id: root

	readonly property int selectedItemsCount: checkedElements.count

	property bool showCloseButtons: true
	property UI.PaletteBasic chipAccent: root.accent

	signal toggleElement(index : int)

	function append(name) : void {
		checkedElements.append({"name": name})
	}

	implicitHeight: Math.max(UI.Size.scale * 48, implicitContentHeight)

	popup.closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnEscape
	showPlaceholder: checkedElements.count === 0 && !root.focus
	checkable: true

	Keys.onSpacePressed: {
		if (!root.popup.opened) {
			root.popup.open();
			return;
		}

		if (root.highlightedIndex < 0)
			return;

		const selectedText = root.textAt(root.highlightedIndex)

		if (selectedText !== "")
			checkedElements.toggleByName(selectedText)
	}

	delegate: Controls.MenuItem {
		id: menuItemRoot

		required property int index
		required property var model

		function loadCheckedState() {
			if (checkedElements.count === 0)
				return

			for (let index = 0; index < checkedElements.count; index++) {
				if (checkedElements.get(index).name === text) {
					menuItemRoot.checked = true
					return
				}
			}

			menuItemRoot.checked = false
		}

		theme: root.theme
		checkable: root.checkable
		implicitHeight: root.delegateHeight
		horizontalPadding: UI.Size.pixel12
		width: ListView.view.width
		useIcons: false
		highlighted: root.highlightedIndex === index
		hoverEnabled: root.hoverEnabled
		color: highlighted || root.currentIndex === index ? root.theme.text.primary : root.theme.text.secondary

		text: model[root.textRole]

		Component.onCompleted: menuItemRoot.loadCheckedState()

		onToggled: {
			if (checked)
				root.append(text)
			else {
				checkedElements.removeByName(text)
			}
		}

		Connections {
			target: checkedElements

			function onCountChanged() {
				menuItemRoot.loadCheckedState()
			}
		}
	}

	contentItem: Item {
		id: contentRoot

		property real padding: UI.Size.pixel6

		implicitHeight: flow.implicitHeight + UI.Size.pixel24
		clip: true

		Flow {
			id: flow

			spacing: UI.Size.pixel6

			anchors {
				fill: contentRoot
				topMargin: root.type == Controls.TextField.Type.Outlined ? UI.Size.pixel12 : UI.Size.pixel20
				margins: UI.Size.pixel14
				leftMargin: 0
				rightMargin: 0
			}

			move: Transition {
				UI.EasedAnimation {
					properties: "x,y"
				}
			}

			add: Transition {
				UI.EasedAnimation {
					properties: "opacity"
					from: 0
					to: 1
					duration: 180
				}
				UI.EasedAnimation {
					properties: "scale"
					from: 0.8
					to: 1
				}
			}

			Repeater {
				model: checkedElements
				delegate: Controls.Chip {
					required property int index
					required property string name

					accent: root.chipAccent
					text: name

					xButton {
						visible: root.showCloseButtons
						onClicked: checkedElements.removeByName(name)
					}
				}
			}
		}
	}

	Behavior on implicitHeight { UI.EasedAnimation { duration: 200 } }

	ListModel {
		id: checkedElements

		function toggleByName(name : string) {
			for (let i = 0; i < count; i++) {
				if (checkedElements.get(i).name === name) {
					remove(i);
					return;
				}
			}
			root.append(name);
		}

		function removeByName(name : string) {
			for (let i = 0; i < count; i++) {
				if (checkedElements.get(i).name === name) {
					remove(i);
					return;
				}
			}
		}

		function loadDisplayText() {
			if (count === 0) {
				root.displayText = "";
				return;
			}

			let allNames = []
			for (let i = 0; i < count; i++) {
				allNames.push(checkedElements.get(i).name)
			}

			root.displayText = allNames.join(", ");
		}

		onCountChanged: loadDisplayText()
		Component.onCompleted: loadDisplayText()
	}

	QtObject {
		id: d

		readonly property real horizontalPadding: root.height / 4

		property list<string> checkedElements: []
	}
}
