import QtQuick 
import QtQuick.Layouts

import MMaterial.UI as UI

RowLayout {
    id: _root

	property real lineWidth: UI.Size.pixel4

	property UI.PaletteBasic accent: UI.Theme.primary
    property color foregroundColor: accent.main
    property color backgroundColor: accent.transparent.p24
    property bool showLabel: false
    property bool indeterminate: false
    property bool smooth: true
    
    property alias barHeight: _bar.height
    property alias label: _label

    property int progress: 50

    implicitWidth: 300
	implicitHeight: UI.Size.pixel10

    // Indeterminate sweep is driven by the shared IndeterminateClock so every
    // progress bar on screen moves in lock-step from a single animation job, and
    // there is no per-bar layer to re-grab each frame. The ticket keeps the clock
    // running only while this bar is actually animating.
    UI.IndeterminateClockTicket { active: _root.indeterminate && _root.visible }

    Rectangle {
        id: _bar

        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.preferredHeight: _root.lineWidth

        color: _root.backgroundColor
        radius: 50
        clip: true
        antialiasing: true

        Rectangle {
            id: _innerBar

            anchors {
                top: _bar.top
                left: _bar.left
                bottom: _bar.bottom
                leftMargin: _root.indeterminate ? UI.IndeterminateClock.phase * (_bar.width - _innerBar.width) : 0
            }

            width: _root.indeterminate ? _bar.width * 0.25 : _root.progress * _bar.width / 100

            antialiasing: true
            color: _root.foregroundColor
            radius: _bar.radius

            Behavior on width { enabled: !_root.indeterminate && _root.smooth; SmoothedAnimation { duration: 50;} }
        }
    }

    UI.Caption {
        id: _label

        Layout.preferredWidth: contentWidth
        Layout.alignment: Qt.AlignVCenter

        visible: _root.showLabel
		color: UI.Theme.text.secondary
        text: _root.progress + "%"
        verticalAlignment: Qt.AlignVCenter
    }
}
