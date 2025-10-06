import QtQuick
import QtQuick.Controls

import MMaterial.UI as UI
import MMaterial.Controls as Controls
import MMaterial.Controls.Inputs as Inputs

Inputs.ComboBox {
	id: root

	property bool showCloseButtons: true
	property UI.PaletteBasic chipAccent: root.accent

	implicitHeight: Math.max(UI.Size.scale * 48, implicitContentHeight)

	popup.closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnEscape
	showPlaceholder: checkedElements.count === 0 && !root.focus
	checkable: true


	delegate: Controls.MenuItem {
		required property int index
		required property var model

		checkable: root.checkable
		implicitHeight: root.delegateHeight
		horizontalPadding: UI.Size.pixel12
		width: ListView.view.width
		useIcons: false
		highlighted: root.highlightedIndex === index
		hoverEnabled: root.hoverEnabled
		color: highlighted || root.currentIndex === index ? UI.Theme.text.primary : UI.Theme.text.secondary

		text: model[root.textRole]

		onCheckedChanged: {
			if (checked)
				checkedElements.append({"name": text})
			else {
				checkedElements.removeByName(text)
			}
		}

		Connections {
			target: checkedElements

			function onFieldRemoved(name) {
				if (name === text) {
					checked = false
				}
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
				topMargin: UI.Size.pixel12
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

		signal fieldRemoved(name : string)

		function removeByName(name) {
			for (let i = 0; i < count; i++) {
				if (get(i).name === name) {
					remove(i);
					checkedElements.fieldRemoved(name)
					return;
				}
			}
		}
	}

	QtObject {
		id: d

		readonly property real horizontalPadding: root.height / 4

		property list<string> checkedElements: []
	}
}
