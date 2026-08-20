pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import MMaterial.UI as UI
import MMaterial.Media as Media
import MMaterial.Controls as Controls
import MMaterial.Controls.Dialogs as Dialogs

Item {
    id: _root

    property var _entries: []
    property int _index: 0

    property bool _closing: false

    readonly property var _current: _index >= 0 && _index < _entries.length
                                    ? _entries[_index]
                                    : null
    readonly property int _position: _index + 1
    readonly property int _total: _entries.length
    readonly property int _maxPips: 8

    readonly property var _pips: {
        const pips = [];
        for (let i = 0; i < _root._entries.length; ++i) {
            const details = _root._entries[i].details;
            pips.push({
                state: i === _root._index ? "current" : (i < _root._index ? "done" : "upcoming"),
                severity: details.severity !== undefined
                          ? details.severity
                          : Controls.Alert.Severity.Info
            });
        }
        return pips;
    }

    function severityPalette(severity: int) : UI.PaletteBasic {
        if (severity === Controls.Alert.Severity.Success) return UI.Theme.success;
        if (severity === Controls.Alert.Severity.Warning) return UI.Theme.warning;
        if (severity === Controls.Alert.Severity.Error) return UI.Theme.error;
        return UI.Theme.info;
    }

    function _present(message, details): void {
        const entry = { message: message, details: details };

        if (_dialog.visible && !_root._closing) {
            _root._entries = _root._entries.concat([entry]);
            return;
        }

        _root._closing = false;
        _root._entries = [entry];
        _root._index = 0;
        _stack.clear();
        _stack.push(_pageComponent, entry, StackView.Immediate);
        _dialog.open();
    }

    function _goTo(index): void {
        if (index < 0 || index >= _root._entries.length || index === _root._index)
            return;

        _root._index = index;
        _stack.replace(_pageComponent, _root._entries[index]);
    }

    function _advance(): void {
        if (_root._current)
            Controls.NotificationCenter.dismissModal(_root._current.details);

        if (_root._index < _root._entries.length - 1) {
            _root._goTo(_root._index + 1);
            return;
        }

        _root._closing = true;
        _dialog.close();
    }

    Connections {
        target: Controls.NotificationCenter

        function onModalRequested(message, details): void {
            _root._present(message, details);
        }
    }

    Dialogs.Dialog {
        id: _dialog

        readonly property var currentDetails: _root._current ? _root._current.details : ({})
        readonly property int severity: currentDetails.severity !== undefined
                                        ? currentDetails.severity
                                        : Controls.Alert.Severity.Info
        readonly property UI.PaletteBasic accent: _root.severityPalette(_dialog.severity)

        parent: Overlay.overlay
        anchors.centerIn: parent
        modal: true
        closePolicy: Popup.NoAutoClose
        maxWidth: 560 * UI.Size.scale
        width: Math.min(_dialog.maxWidth, 520 * UI.Size.scale)

        title: currentDetails.title !== undefined && currentDetails.title !== ""
               ? currentDetails.title
               : qsTr("Notification")

        onClosed: {
            _stack.clear();
            _root._entries = [];
            _root._index = 0;
            _root._closing = false;
        }

        header: Item {
            id: _header

            implicitHeight: _headerLayout.implicitHeight + _dialog.topPadding

            RowLayout {
                id: _headerLayout

                spacing: UI.Size.pixel10

                anchors {
                    left: _header.left
                    leftMargin: _dialog.leftPadding
                    right: _header.right
                    rightMargin: _dialog.rightPadding
                    bottom: _header.bottom
                }

                Media.Icon {
                    Layout.alignment: Qt.AlignVCenter
                    size: _dialog.iconSize
                    color: _dialog.accent.main.toString()
                    iconData: {
                        if (_dialog.severity === Controls.Alert.Severity.Success)
                            return Media.Icons.light.checkCircle;
                        if (_dialog.severity === Controls.Alert.Severity.Warning)
                            return Media.Icons.light.warning;
                        return Media.Icons.light.info;
                    }
                }

                UI.H6 {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: _dialog.title
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                    color: UI.Theme.text.primary
                }

                Row {
                    Layout.alignment: Qt.AlignVCenter
                    visible: _root._total > 1 && _root._total <= _root._maxPips

                    Repeater {
                        model: _root._pips

                        delegate: Item {
                            id: _pip

                            required property var modelData

                            height: UI.Size.pixel18
                            width: _dot.width + UI.Size.pixel5

                            Rectangle {
                                id: _dot

                                readonly property bool checked: _pip.modelData.state === "current"

                                anchors.centerIn: _pip

                                height: UI.Size.pixel6 + UI.Size.pixel1
                                width: height
                                radius: 100
                                color: _pip.modelData.state === "done"
                                       ? UI.Theme.text.disabled
                                       : _root.severityPalette(_pip.modelData.severity).main

                                states: [
                                    State {
                                        name: "checked"
                                        when: _dot.checked

                                        PropertyChanges {
                                            _dot.opacity: 1
                                            _dot.width: _dot.height * 2.2
                                        }
                                    },
                                    State {
                                        name: "unchecked"
                                        when: true

                                        PropertyChanges {
                                            _dot.opacity: 0.32
                                            _dot.width: _dot.height
                                        }
                                    }
                                ]

                                transitions: [
                                    Transition {
                                        from: "*"
                                        NumberAnimation {
                                            properties: "width"
                                            duration: 1300
                                            easing.type: Easing.OutElastic
                                        }
                                        NumberAnimation {
                                            properties: "opacity"
                                            duration: 300
                                        }
                                    }
                                ]
                            }
                        }
                    }
                }

                UI.Caption {
                    Layout.alignment: Qt.AlignVCenter
                    visible: _root._total > 1
                    text: qsTr("%1 of %2").arg(_root._position).arg(_root._total)
                    color: UI.Theme.text.disabled
                }
            }
        }

        contentItem: ColumnLayout {
            spacing: UI.Size.pixel12

            StackView {
                id: _stack

                Layout.fillWidth: true
                Layout.preferredHeight: currentItem ? currentItem.implicitHeight : 0
                clip: true

                Behavior on Layout.preferredHeight {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }

        Dialogs.Dialog.DialogButton {
            text: _root._index < _root._total - 1 ? qsTr("Next") : qsTr("Close")

            onClicked: _root._advance()
        }
    }

    Component {
        id: _pageComponent

        ColumnLayout {
            id: _page

            property string message
            property var details: ({})

            readonly property var fields: details.fields !== undefined ? details.fields : []

            readonly property var sections: {
                const result = [];
                let current = [];
                for (const field of _page.fields) {
                    if (field.separator === true) {
                        if (current.length > 0) {
                            result.push(current);
                            current = [];
                        }
                        continue;
                    }
                    current.push(field);
                }
                if (current.length > 0)
                    result.push(current);
                return result;
            }

            spacing: UI.Size.pixel16

            UI.B1 {
                Layout.fillWidth: true
                text: _page.message
                wrapMode: Text.WordWrap
                color: UI.Theme.text.primary
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                visible: _page.fields.length > 0
                color: UI.Theme.other.divider
            }

            Repeater {
                model: _page.sections

                delegate: ColumnLayout {
                    id: _section

                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    spacing: UI.Size.pixel12

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        visible: _section.index > 0
                        color: UI.Theme.other.divider
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rows: Math.ceil(_section.modelData.length / 2)
                        flow: GridLayout.TopToBottom
                        columnSpacing: UI.Size.pixel24
                        rowSpacing: UI.Size.pixel12

                        Repeater {
                            model: _section.modelData

                            delegate: ColumnLayout {
                                id: _field

                                required property var modelData

                                Layout.fillWidth: true
                                Layout.preferredWidth: 1
                                spacing: UI.Size.pixel2

                                UI.Overline {
                                    Layout.fillWidth: true
                                    text: _field.modelData.title
                                    elide: Text.ElideRight
                                    wrapMode: Text.NoWrap
                                    color: UI.Theme.text.disabled
                                }

                                UI.Subtitle1 {
                                    Layout.fillWidth: true
                                    text: _field.modelData.value
                                    elide: Text.ElideRight
                                    wrapMode: Text.NoWrap
                                    color: UI.Theme.text.primary
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
