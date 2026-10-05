pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Templates as T

import MMaterial.UI as UI
import MMaterial.Controls as Controls
import MMaterial.Controls.Inputs as Inputs
import MMaterial.Media as Media

T.ComboBox {
	id: root

	property int delegateCount: 5
	property real delegateHeight: UI.Size.pixel46
	property int type: Inputs.TextField.Type.Outlined
	property UI.PaletteBasic accent: UI.Theme.primary
	property Media.IconData iconData: null
	property string placeholderText: qsTr("Placeholder")
	property color placeholderTextColor: UI.Theme.text.primary
	property alias color: _textField.color

	// Typing into the field narrows the list to the items filterFunction(itemText, typedText) takes
	// (by default case- and accent-insensitive, "c" finds "č"); a tap, or Up/Down and Enter, picks
	// one as in a plain ComboBox (currentIndex, activated). Unlike `editable` nothing is
	// autocompleted and the text never becomes the value. Esc or a tap outside closes the list and
	// shows the current item again; closing it with the text cleared picks emptyIndex (-1: nothing).
	property bool filterable: false
	property var filterFunction: (text, filter) => d.fold(text).includes(d.fold(filter))
	property int emptyIndex: -1
	property string noMatchText: qsTr("No matches")
	// What the user typed while the list is filtered, else ""
	readonly property string filterText: d.filtering ? d.filterText : ""

	implicitHeight: 48 * UI.Size.scale
	implicitWidth: (UI.Size.format == UI.Size.Format.Extended ? 319 : 200) * UI.Size.scale
	down: _contextMenu.opened
	selectTextByMouse: true

	model: ["Label 1", "Label 2", "Label 3", "Label 4", "Label 5"]

	leftPadding: (root.type === Inputs.TextField.Type.Standard ? 0 : d.horizontalPadding) + (_leftIcon.visible ? _leftIcon.width + UI.Size.pixel8 : 0) + (!root.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
	rightPadding: d.horizontalPadding + (root.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

	font {
		family: UI.PublicSans.regular
		pixelSize: UI.Size.pixel14
	}

	onActivated: d.picked = true

	QtObject{
		id: d

		readonly property real horizontalPadding: root.height / 4

		// Filterable: the typed text and whether it narrows the list
		property string filterText: ""
		property bool filtering: false
		// An item was picked while the list was open
		property bool picked: false
		readonly property var matchingIndexes: {
			const indexes = [];
			for (let i = 0; i < root.count; ++i) {
				if (d.matches(i, d.filtering ? d.filterText : ""))
					indexes.push(i);
			}
			return indexes;
		}

		// Lower case without accents: the combining marks U+0300 to U+036F that NFD splits off
		readonly property var accents: new RegExp(`[${String.fromCharCode(0x300)}-${String.fromCharCode(0x36f)}]`, "g")

		function fold(text: var): string {
			return String(text ?? "").toLocaleLowerCase().normalize("NFD").replace(d.accents, "");
		}

		function matches(index: int, filter: string): bool {
			return filter.trim() === "" || root.filterFunction(root.textAt(index), filter.trim());
		}

		// Moves the highlight as the combo box's own Up/Down do while the list is open
		function highlight(index: int) {
			if (index < 0 || index >= root.count)
				return;
			while (root.highlightedIndex < index && root.highlightedIndex < root.count - 1)
				root.incrementCurrentIndex();
			while (root.highlightedIndex > index && root.highlightedIndex > 0)
				root.decrementCurrentIndex();
		}

		function step(forward: bool) {
			const indexes = d.matchingIndexes;
			if (indexes.length === 0)
				return;
			const at = indexes.indexOf(root.highlightedIndex);
			if (at === -1)
				d.highlight(forward ? indexes[0] : indexes[indexes.length - 1]);
			else
				d.highlight(indexes[Math.max(0, Math.min(indexes.length - 1, at + (forward ? 1 : -1)))]);
		}

		// As a tap on its row: the combo box sets currentIndex itself, so a binding on it stays
		function pick(index: int) {
			if (index < 0 || index >= root.count)
				return;
			_listView.forceLayout();
			_listView.positionViewAtIndex(index, ListView.Contain);
			const item = _listView.itemAtIndex(index) as T.AbstractButton;
			if (item)
				item.clicked();
		}

		function startFiltering(text: string) {
			d.filterText = text;
			d.filtering = true;
			if (!_contextMenu.visible)
				_contextMenu.open();
			// The first match is what Enter takes
			const indexes = d.matchingIndexes;
			if (indexes.length > 0 && indexes.indexOf(root.highlightedIndex) === -1)
				d.highlight(indexes[0]);
			if (indexes.length > 0) {
				_listView.forceLayout();
				_listView.positionViewAtIndex(root.highlightedIndex, ListView.Contain);
			}
		}

		function stopFiltering() {
			const cleared = d.filtering && d.filterText.trim() === "" && !d.picked;
			d.filtering = false;
			d.filterText = "";
			d.picked = false;
			// Once the list has closed, as a tap on that row would
			if (cleared && root.emptyIndex >= 0 && root.emptyIndex !== root.currentIndex)
				Qt.callLater(d.pick, root.emptyIndex);
		}
	}

	Component.onCompleted: if (root.filterable) _textField.focus = true
	// The field takes the keys whenever the combo box has them
	onFilterableChanged: if (root.filterable) _textField.focus = true

	Item {
		id: _mainContainer

		anchors {
			fill: root
			topMargin: root.type === Inputs.TextField.Type.Outlined ? 0 : (root.activeFocus ? UI.Size.pixel16 : 0)
		}

		Media.Icon {
			id: _leftIcon

			anchors {
				left: _mainContainer.left; leftMargin: root.type === Inputs.TextField.Type.Standard ? 0 : d.horizontalPadding;
				verticalCenter: _mainContainer.verticalCenter
			}

			iconData: root.iconData
			color: UI.Theme.text.disabled.toString()
			visible: iconData
			size: !visible ? 0 : bg.height * 0.3
		}
	}

	background: Inputs.InputsBackground {
		id: bg

		rootItem: root
		ignoreDisabledColoring: root.enabled
		showPlaceholder: !root.focus && root.displayText === "" && !root.down && root.placeholderText !== ""
		leftIcon: _leftIcon
		iconContainer: _mainContainer
	}

	contentItem: T.TextField {
		id: _textField

		text: root.editable ? root.editText : d.filtering ? d.filterText : root.displayText
		placeholderText: ""
		enabled: root.editable || root.filterable
		autoScroll: root.editable || root.filterable
		readOnly: root.filterable ? false : root.down
		inputMethodHints: root.inputMethodHints
		validator: root.validator
		selectByMouse: root.selectTextByMouse
		verticalAlignment: Text.AlignVCenter

		implicitHeight: 52 * UI.Size.scale
		implicitWidth: (UI.Size.format == UI.Size.Format.Extended ? 319 : 200) * UI.Size.scale

		selectedTextColor: acceptableInput ? root.accent.contrastText : UI.Theme.error.contrastText
		selectionColor: acceptableInput ? root.accent.main : UI.Theme.error.main
		placeholderTextColor: UI.Theme.text.primary.toString() 

		topPadding: root.type === Inputs.TextField.Type.Standard || root.type === Inputs.TextField.Type.Filled ? root.height * 0.3 : 0

		// Filterable: a tap opens the list with the text selected, so typing replaces it. The field
		// takes the focus after the release and drops a selection made before, hence later.
		onPressed: if (root.filterable && !_contextMenu.visible) _contextMenu.open()
		onReleased: if (root.filterable && !d.filtering) Qt.callLater(_textField.selectAll)
		onTextEdited: if (root.filterable) d.startFiltering(_textField.text)
		onActiveFocusChanged: if (root.filterable && !_textField.activeFocus) _contextMenu.close()

		// The list doesn't take the focus from the field, so the field handles its keys. Their releases
		// stay here too: the combo box would take a Space's as a tap and an Enter's as a pick
		Keys.onShortcutOverride: event => event.accepted = root.filterable && _contextMenu.visible && event.key === Qt.Key_Escape
		Keys.onReleased: event => event.accepted = root.filterable
		Keys.onPressed: event => {
			if (!root.filterable)
				return;
			switch (event.key) {
			case Qt.Key_Escape:
				if (!_contextMenu.visible)
					return;
				// Back to the current item, nothing picked
				d.filtering = false;
				_contextMenu.close();
				break;
			case Qt.Key_Down:
				if (_contextMenu.visible)
					d.step(true);
				else
					_contextMenu.open();
				break;
			case Qt.Key_Up:
				if (_contextMenu.visible)
					d.step(false);
				break;
			case Qt.Key_Return:
			case Qt.Key_Enter:
				if (_contextMenu.visible && d.filtering && d.filterText.trim() === "" && root.emptyIndex >= 0)
					d.pick(root.emptyIndex);
				else if (_contextMenu.visible && d.matchingIndexes.indexOf(root.highlightedIndex) !== -1)
					d.pick(root.highlightedIndex);
				else
					_contextMenu.close();
				break;
			default:
				return;
			}
			event.accepted = true;
		}
	}

	indicator: Media.Icon {
		x: root.mirrored ? root.padding : (root.width - width) - UI.Size.pixel8
		y: root.topPadding + (root.availableHeight - height) / 2
		rotation: root.down ? 180 : 0
		iconData: Media.Icons.light.keyboardArrowDown
		size: UI.Size.pixel22
		color: root.enabled ? UI.Theme.action.active.toString() : UI.Theme.action.disabled.toString()

		Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
	}

	delegate: Controls.MenuItem {
		required property int index
		required property var model

		// Filtered out: no room in the list and nothing to tap
		visible: !d.filtering || d.matchingIndexes.indexOf(index) !== -1
		implicitHeight: visible ? root.delegateHeight : 0
		horizontalPadding: UI.Size.pixel12
		width: ListView.view.width
		useIcons: false
		highlighted: root.highlightedIndex === index
		hoverEnabled: root.hoverEnabled
		color: highlighted || root.currentIndex === index ? UI.Theme.text.primary : UI.Theme.text.secondary

		text: model[root.textRole]
	}

	popup: Controls.Menu {
		id: _contextMenu

		width: root.width
		height: Math.min(contentItem.implicitHeight + verticalPadding * 2, root.Window.height - topMargin - bottomMargin)
		transformOrigin: Item.Top
		verticalPadding: UI.Size.pixel8

		y: root.height + 1
		closePolicy: Controls.Menu.CloseOnEscape | Controls.Menu.CloseOnReleaseOutsideParent
		// Filterable: the keys stay with the field being typed into
		focus: !root.filterable

		onAboutToShow: {
			root.down = true;
			d.picked = false;
		}
		onAboutToHide: {
			root.down = false;
			if (root.filterable)
				d.stopFiltering();
		}

		background: Rectangle {
			implicitWidth: root.width

			radius: UI.Size.pixel12
			color: UI.Theme.background.main
			border.color: UI.Theme.action.disabledBackground
		}

		contentItem: ListView {
			id: _listView

			implicitHeight: !root.filterable ? (count > root.delegateCount ? root.delegateCount * root.delegateHeight : contentHeight)
							: Math.max(1, Math.min(d.matchingIndexes.length, root.delegateCount)) * root.delegateHeight

			model: root.delegateModel

			clip: true
			currentIndex: root.highlightedIndex

			ScrollIndicator.vertical: T.ScrollIndicator {}

			UI.B2 {
				// Over the list rather than in its content, which has no height without matches
				parent: _listView
				anchors.centerIn: parent
				visible: root.filterable && d.matchingIndexes.length === 0
				text: root.noMatchText
				color: UI.Theme.text.secondary
			}
		}
	}
}
