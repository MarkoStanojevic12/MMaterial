pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T

import MMaterial.UI as UI

T.Popup {
    id: control

    // An X in the top-right corner that closes the popup, above the content
    property bool showXButton: false

    readonly property CloseButton xButton: CloseButton {
        // The popup's own item, which holds the background and the content
        parent: control.contentItem ? control.contentItem.parent : null
        x: parent ? parent.width - width - UI.Size.pixel4 : 0
        y: UI.Size.pixel4
        z: 1
        visible: control.showXButton

        onClicked: control.close()
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    // A modal popup takes the keyboard, so Esc closes it (closePolicy permitting) and the keys don't
    // reach the page behind it. A modeless one leaves it where it is. Set it false for a modal
    // popup that only informs (a loading screen).
    focus: control.modal

    background: Rectangle {
		radius: UI.Size.pixel6
		implicitWidth:  UI.Size.scale * 420
		implicitHeight: UI.Size.pixel36
		color: UI.Theme.background.paper
		border.color:  UI.Theme.background.neutral
    }

    T.Overlay.modal: Rectangle {
        color: Qt.alpha(control.palette.shadow, 0.5)
    }

    T.Overlay.modeless: Rectangle {
        color: Qt.alpha(control.palette.shadow, 0.12)
    }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }
}
