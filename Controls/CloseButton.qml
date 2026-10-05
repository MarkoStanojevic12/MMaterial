import QtQuick

import MMaterial.UI as UI
import MMaterial.Media as Media

// An X that closes a popup or dialog. The icon is small, the area that takes the tap is big enough
// for a finger, and a round highlight shows it on hover and press.
Item {
	id: _root

	property real iconSize: UI.Size.pixel16
	property color color: UI.Theme.text.primary

	readonly property alias pressed: _mouseArea.pressed
	readonly property alias hovered: _mouseArea.containsMouse

	signal clicked

	implicitWidth: UI.Size.pixel40
	implicitHeight: UI.Size.pixel40

	Accessible.role: Accessible.Button
	Accessible.name: qsTr("Close")
	Accessible.onPressAction: _root.clicked()

	Rectangle {
		anchors.fill: _root
		radius: width / 2
		color: _mouseArea.pressed ? UI.Theme.action.selected : _mouseArea.containsMouse ? UI.Theme.action.hover : "transparent"
	}

	Media.Icon {
		anchors.centerIn: _root
		iconData: Media.Icons.light.close
		size: _root.iconSize
		color: _root.enabled ? _root.color.toString() : UI.Theme.action.disabled.toString()
	}

	MouseArea {
		id: _mouseArea

		anchors.fill: _root
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor

		onClicked: _root.clicked()
	}
}
