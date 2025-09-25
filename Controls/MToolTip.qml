import QtQuick
import QtQuick.Templates as T

import MMaterial.UI as UI

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 3

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: UI.Size.pixel6
    leftPadding: UI.Size.pixel12
    rightPadding: UI.Size.pixel12
    topPadding: UI.Size.pixel8
    bottomPadding: UI.Size.pixel8

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    contentItem: Text {
        text: control.text
        wrapMode: Text.Wrap
		color: UI.Theme.background.main
        font {
            pixelSize: UI.Size.pixel14
            family: UI.Font.normal
        }
    }

    background: Rectangle {
        radius: UI.Size.pixel10
		color: UI.Theme.text.primary

        border {
            width: 1
            color: UI.Theme.other.outline
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutQuad; duration: 500 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.InQuad; duration: 500 }
    }
}
