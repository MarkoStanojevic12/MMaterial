pragma ComponentBehavior: Bound

import QtQuick

import MMaterial.UI as UI

FocusScope {
    id: root

    property int length: 5
    property string text: ""
    property UI.PaletteBasic accent: UI.Theme.primary
    property bool enabled: true
    property bool acceptableInput: true
    property alias validator: d.validator
    property real spacing: UI.Size.pixel8
    property real segmentSize: UI.Size.pixel48
    property real fontSize: UI.Size.pixel28
    property int inputMethodHints: Qt.ImhNoPredictiveText

    readonly property int maxLength: 1

    signal editingFinished()
    signal inputTextChanged(string text)

    function clear() {
        for (let i = 0; i < d.segments.length; i++) {
            if (d.segments[i]) {
                d.segments[i].text = ""
            }
        }
        d.updateText()
        focusSegment(0)
    }

    function focusSegment(index) {
        if (index >= 0 && index < d.segments.length && d.segments[index]) {
            d.segments[index].forceActiveFocus()
        }
    }

    implicitWidth: root.length * (root.segmentSize + root.spacing) - root.spacing
    implicitHeight: root.segmentSize

    QtObject {
        id: d

        property var validator: RegularExpressionValidator { regularExpression: /^.$/ }
        property list<TextInput> segments: Array(root.length).fill(null)
        property int pasteStartIndex: 0
        property bool pasteHandled: false
        property bool initializing: true
        property string initialText: ""

        Component.onCompleted: {
            initialText = root.text
        }

        function updateText() {
            if (initializing) return

            let newText = ""
            for (let i = 0; i < segments.length; i++) {
                if (segments[i]) {
                    newText += segments[i].text
                }
            }
            if (root.text !== newText) {
                root.text = newText
                root.inputTextChanged(newText)
            }
        }

        function moveToNext(currentIndex) {
            if (currentIndex < segments.length - 1) {
                root.focusSegment(currentIndex + 1)
            } else {
                root.editingFinished()
            }
        }

        function moveToPrevious(currentIndex) {
            if (currentIndex > 0) {
                root.focusSegment(currentIndex - 1)
            }
        }

        function handlePaste(pastedText: string) {
            let segmentIndex = pasteStartIndex

            for (let charIndex = 0; charIndex < pastedText.length && segmentIndex < segments.length; charIndex++) {
                let ch = pastedText[charIndex]

                if (segments[segmentIndex]) {
                    let oldText = segments[segmentIndex].text
                    segments[segmentIndex].text = ch

                    if (segments[segmentIndex].text === ch) {
                        segmentIndex++
                    } else {
                        segments[segmentIndex].text = oldText
                    }
                }
            }

            updateText()

            let focusIndex = Math.min(segmentIndex, segments.length - 1)
            root.focusSegment(focusIndex)

            if (segmentIndex >= segments.length) {
                root.editingFinished()
            }
        }
    }

    TextInput {
        id: pasteHelper
        visible: false

        onTextChanged: {
            if (text.length > 0) {
                d.pasteHandled = true
                d.handlePaste(text)
                text = ""
            }
        }
    }

    GridView {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        readonly property real minWidthNeeded: root.length * root.segmentSize + (root.length - 1) * root.spacing
        readonly property bool canFitAllInOneRow: width >= minWidthNeeded

        cellWidth: canFitAllInOneRow ?
                       root.segmentSize + (root.spacing * (root.length - 1)) / root.length :
                       root.segmentSize
        cellHeight: root.segmentSize + root.spacing
        model: root.length
        interactive: false
        flow: GridView.FlowLeftToRight

        delegate: TextInput {
            id: segmentInput
            required property int index

            width: root.segmentSize
            height: root.segmentSize

            maximumLength: root.maxLength
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            enabled: root.enabled
            validator: d.validator
            inputMethodHints: root.inputMethodHints

            color: root.enabled ? UI.Theme.text.primary : UI.Theme.text.disabled
            selectionColor: root.acceptableInput ? root.accent.main : UI.Theme.error.main
            selectedTextColor: root.acceptableInput ? root.accent.contrastText : UI.Theme.error.contrastText

            font {
                pixelSize: root.fontSize
                bold: true
            }

            Rectangle {
                anchors.fill: parent
                radius: UI.Size.pixel8
                color: UI.Theme.background.paper
                border {
                    width: 1
                    color: {
                        if (!root.enabled) return UI.Theme.action.disabledBackground
                        if (!root.acceptableInput) return UI.Theme.error.main
                        if (parent.activeFocus) return root.accent.main
                        return UI.Theme.other.divider
                    }
                }
                z: -1
            }

            Component.onCompleted: {
                d.segments[index] = segmentInput
                if (index < d.initialText.length) {
                    text = d.initialText[index]
                }
            }

            onTextChanged: {
                d.updateText()
                if (text.length === root.maxLength && text !== "") {
                    d.moveToNext(index)
                }
            }

            onActiveFocusChanged: {
                if (activeFocus) {
                    selectAll()
                }
            }

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Backspace && text === "") {
                    event.accepted = true
                    d.moveToPrevious(index)
                } else if (event.key === Qt.Key_Left) {
                    event.accepted = true
                    d.moveToPrevious(index)
                } else if (event.key === Qt.Key_Right) {
                    event.accepted = true
                    d.moveToNext(index)
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    event.accepted = true
                    root.editingFinished()
                } else if (event.key === Qt.Key_V && (event.modifiers & Qt.ControlModifier)) {
                    event.accepted = true
                    d.pasteStartIndex = index
                    d.pasteHandled = false
                    pasteHelper.forceActiveFocus()
                    pasteHelper.selectAll()
                    pasteHelper.paste()
                    if (!d.pasteHandled) {
                        root.focusSegment(index)
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        d.initializing = false
        Qt.callLater(() => root.focusSegment(0))
    }
}
