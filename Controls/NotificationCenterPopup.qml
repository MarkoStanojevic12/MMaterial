pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import MMaterial.UI as UI
import MMaterial.Media as Media
import MMaterial.Controls as Controls

Controls.Popup {
    id: _root

    property real maxListHeight: 420 * UI.Size.scale
    property real placeholderHeight: 150 * UI.Size.scale
    property bool clearing: false

    property var extraActions: []

    function actionApplies(action, notification) : bool {
        if (!action || !action.trigger)
            return false;
        return action.shows === undefined || action.shows(notification);
    }

    width: 400 * UI.Size.scale
    padding: UI.Size.pixel20
    topPadding: UI.Size.pixel16

    background: Rectangle {
        radius: UI.Size.pixel16
        color: UI.Theme.background.paper
        border.color: UI.Theme.background.neutral
    }

    onOpened: Controls.NotificationCenter.markAllRead()
    onClosed: Controls.NotificationCenter.severityFilter = _root.allSeverities

    readonly property int allSeverities: -1

    function severityPalette(severity: int) : UI.PaletteBasic {
        if (severity === Controls.Alert.Severity.Success) return UI.Theme.success;
        if (severity === Controls.Alert.Severity.Warning) return UI.Theme.warning;
        if (severity === Controls.Alert.Severity.Error) return UI.Theme.error;
        return UI.Theme.info;
    }

    function severityLabel(severity: int) : string {
        if (severity === Controls.Alert.Severity.Success) return qsTr("Success");
        if (severity === Controls.Alert.Severity.Warning) return qsTr("Warnings");
        if (severity === Controls.Alert.Severity.Error) return qsTr("Errors");
        return qsTr("Info");
    }

    contentItem: ColumnLayout {
        spacing: UI.Size.pixel12

        RowLayout {
            Layout.fillWidth: true
            spacing: UI.Size.pixel8

            UI.H6 {
                Layout.fillWidth: true
                text: qsTr("Notifications")
                elide: Text.ElideRight
            }

            Controls.MButton {
                size: UI.Size.Grade.S
                type: Controls.MButton.Type.Text
                accent: UI.Theme.passive
                text: qsTr("Clear all")
                visible: Controls.NotificationCenter.count > 0
                enabled: !_clearAnimation.running

                onClicked: _clearAnimation.restart()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: UI.Size.pixel4
            visible: Controls.NotificationCenter.severities.length > 1

            Controls.MButton {
                id: _allSeveritiesButton

                size: UI.Size.Grade.S
                readonly property bool selected:
                    Controls.NotificationCenter.severityFilter === _root.allSeverities

                type: _allSeveritiesButton.selected ? Controls.MButton.Type.Contained
                                                    : Controls.MButton.Type.Soft
                accent: _allSeveritiesButton.selected ? UI.Theme.primary : UI.Theme.passive
                text: qsTr("All")

                onClicked: Controls.NotificationCenter.severityFilter = _root.allSeverities
            }

            ListView {
                id: _severityList

                Layout.fillWidth: true
                Layout.preferredHeight: _allSeveritiesButton.implicitHeight
                orientation: ListView.Horizontal
                spacing: UI.Size.pixel4
                clip: true
                model: Controls.NotificationCenter.severities

                Controls.ScrollBar.horizontal: Controls.ScrollBar {}

                delegate: Controls.MButton {
                    id: _severityButton

                    required property var modelData

                    readonly property bool selected:
                        Controls.NotificationCenter.severityFilter === _severityButton.modelData.severity

                    height: _severityList.height
                    size: UI.Size.Grade.S
                    accent: _root.severityPalette(_severityButton.modelData.severity)
                    type: _severityButton.selected ? Controls.MButton.Type.Contained
                                                   : Controls.MButton.Type.Soft
                    text: _root.severityLabel(_severityButton.modelData.severity)
                          + " (" + _severityButton.modelData.count + ")"

                    onClicked: Controls.NotificationCenter.severityFilter =
                        _severityButton.selected ? _root.allSeverities
                                                 : _severityButton.modelData.severity
                }
            }
        }

        Item {
            id: _listArea

            Layout.fillWidth: true
            Layout.preferredHeight: (_list.count === 0 || _root.clearing)
                                    ? _root.placeholderHeight
                                    : Math.min(_list.contentHeight, _root.maxListHeight)

            Behavior on Layout.preferredHeight {
                enabled: _root.opened
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }

            ListView {
                id: _list

                anchors.fill: _listArea
                clip: true
                spacing: UI.Size.pixel12
                model: Controls.NotificationCenter

                Controls.ScrollBar.vertical: Controls.ScrollBar {}

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 220; easing.type: Easing.OutCubic }
                }

                remove: Transition {
                    NumberAnimation { property: "opacity"; to: 0; duration: 160; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "x"; to: _list.width * 0.25; duration: 160; easing.type: Easing.OutCubic }
                }

                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220; easing.type: Easing.OutCubic }
                }

                delegate: Rectangle {
                    id: _entry

                    required property int index
                    required property string message
                    required property int severity
                    required property string title
                    required property var timestamp
                    required property bool read
                    required property string groupKey
                    required property var fields

                    readonly property color accentColor: _root.severityPalette(_entry.severity).main

                    readonly property var notification: ({
                        index: _entry.index,
                        message: _entry.message,
                        severity: _entry.severity,
                        title: _entry.title,
                        groupKey: _entry.groupKey,
                        timestamp: _entry.timestamp,
                        fields: _entry.fields
                    })

                    radius: UI.Size.pixel8
                    color: UI.Theme.main.transparent.p12
                    width: _list.width
                    height: Math.max(UI.Size.scale * 60, _entryLayout.implicitHeight + UI.Size.pixel20)
                    clip: true

                    HoverHandler {
                        id: _rowHover
                    }

                    Rectangle {
                        id: _severityFlag

                        color: _entry.accentColor
                        radius: height / 2
                        width: UI.Size.pixel4

                        anchors {
                            left: _entry.left
                            leftMargin: UI.Size.pixel12
                            top: _entry.top
                            topMargin: UI.Size.pixel8
                            bottom: _entry.bottom
                            bottomMargin: UI.Size.pixel8
                        }
                    }

                    ColumnLayout {
                        id: _entryLayout

                        spacing: UI.Size.pixel4

                        anchors {
                            left: _severityFlag.right
                            leftMargin: UI.Size.pixel8
                            right: _entry.right
                            rightMargin: UI.Size.pixel12 + _actionStrip.revealAmount
                            top: _severityFlag.top
                            topMargin: UI.Size.pixel2
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: UI.Size.pixel8

                            UI.Subtitle2 {
                                Layout.fillWidth: true

                                elide: Text.ElideRight
                                wrapMode: Text.NoWrap
                                maximumLineCount: 1
                                text: _entry.title || qsTr("Notification")
                                font {
                                    variableAxes: { "wght": 700 }
                                }
                            }

                            Controls.BadgeDot {
                                Layout.alignment: Qt.AlignVCenter
                                visible: !_entry.read
                                accent: UI.Theme.info
                                pixelSize: UI.Size.pixel8
                            }

                            UI.Caption {
                                Layout.alignment: Qt.AlignVCenter
                                text: Qt.formatTime(_entry.timestamp, "hh:mm")
                                color: UI.Theme.text.disabled
                            }
                        }

                        UI.Subtitle2 {
                            Layout.fillWidth: true

                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap
                            maximumLineCount: 1
                            text: _entry.message

                            font {
                                variableAxes: { "wght": 500 }
                            }
                        }
                    }

                    Item {
                        id: _actionStrip

                        readonly property real actionWidth: UI.Size.pixel56
                        readonly property int actionCount: 1 + _extraActions.count
                        readonly property real revealedWidth: actionCount * actionWidth

                        property real revealAmount: _rowHover.hovered ? revealedWidth : 0

                        width: revealedWidth
                        height: _entry.height
                        x: _entry.width - revealAmount

                        Behavior on revealAmount {
                            NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                        }

                        Rectangle {
                            id: _deleteAction

                            x: 0
                            width: _actionStrip.actionWidth
                            height: _actionStrip.height
                            color: UI.Theme.error.main

                            Media.Icon {
                                anchors.centerIn: _deleteAction
                                iconData: Media.Icons.light.deleteElement
                                size: UI.Size.pixel20
                                color: UI.Theme.error.contrastText.toString()
                            }

                            MouseArea {
                                anchors.fill: _deleteAction
                                cursorShape: Qt.PointingHandCursor

                                onClicked: Controls.NotificationCenter.removeAt(_entry.index)
                            }
                        }

                        Repeater {
                            id: _extraActions

                            model: _root.extraActions.filter(
                                       action => _root.actionApplies(action, _entry.notification))

                            delegate: Rectangle {
                                id: _extraAction

                                required property int index
                                required property var modelData

                                readonly property var accentPalette: _extraAction.modelData.accent
                                                                     ? _extraAction.modelData.accent
                                                                     : UI.Theme.info

                                x: (_extraAction.index + 1) * _actionStrip.actionWidth
                                width: _actionStrip.actionWidth
                                height: _actionStrip.height
                                color: _extraAction.accentPalette.main

                                Media.Icon {
                                    anchors.centerIn: _extraAction
                                    iconData: _extraAction.modelData.iconData
                                    size: UI.Size.pixel20
                                    color: _extraAction.accentPalette.contrastText.toString()
                                }

                                MouseArea {
                                    anchors.fill: _extraAction
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: _extraAction.modelData.trigger(_entry.notification)
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                id: _emptyState

                anchors.centerIn: _listArea
                spacing: UI.Size.pixel8

                opacity: (_list.count === 0 && !_root.clearing) ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }

                Media.Icon {
                    Layout.alignment: Qt.AlignHCenter
                    iconData: Media.Icons.light.notifications
                    size: UI.Size.pixel56
                    color: UI.Theme.text.disabled.toString()
                    opacity: 0.45
                }

                UI.B2 {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("No notifications")
                    color: UI.Theme.text.disabled
                }
            }

            Media.Icon {
                id: _clearIcon

                anchors.centerIn: _listArea
                iconData: Media.Icons.light.deleteElement
                size: UI.Size.pixel56
                color: UI.Theme.text.secondary.toString()
                opacity: 0
                scale: 0.6
                visible: opacity > 0
            }
        }
    }

    SequentialAnimation {
        id: _clearAnimation

        ScriptAction { script: _root.clearing = true }

        ParallelAnimation {
            NumberAnimation {
                target: _list; property: "opacity"; to: 0
                duration: 340; easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: _list; property: "scale"; to: 0.55
                duration: 380; easing.type: Easing.InBack
            }
            NumberAnimation {
                target: _list; property: "rotation"; to: -10
                duration: 380; easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: _clearIcon; property: "opacity"; from: 0; to: 1
                duration: 220; easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: _clearIcon; property: "scale"; from: 0.3; to: 1.2
                duration: 380; easing.type: Easing.OutBack
            }
        }

        ScriptAction { script: Controls.NotificationCenter.clearAll() }

        ParallelAnimation {
            SequentialAnimation {
                NumberAnimation {
                    target: _clearIcon; property: "scale"; to: 0.82
                    duration: 130; easing.type: Easing.InCubic
                }
                NumberAnimation {
                    target: _clearIcon; property: "scale"; to: 1.12
                    duration: 150; easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: _clearIcon; property: "scale"; to: 1
                    duration: 320; easing.type: Easing.OutBounce
                }
            }

            SequentialAnimation {
                NumberAnimation {
                    target: _clearIcon; property: "rotation"; to: -14
                    duration: 120; easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: _clearIcon; property: "rotation"; to: 14
                    duration: 150; easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    target: _clearIcon; property: "rotation"; to: -8
                    duration: 120; easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    target: _clearIcon; property: "rotation"; to: 0
                    duration: 180; easing.type: Easing.OutBack
                }
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: _clearIcon; property: "opacity"; to: 0
                duration: 260; easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: _clearIcon; property: "scale"; to: 0.6
                duration: 260; easing.type: Easing.InCubic
            }
        }

        ScriptAction {
            script: {
                _root.clearing = false;
                _list.opacity = 1;
                _list.scale = 1;
                _list.rotation = 0;
                _clearIcon.rotation = 0;
            }
        }
    }
}