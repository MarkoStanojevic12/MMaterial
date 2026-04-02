import QtQuick
import QtQuick.Templates as T

import MMaterial.UI as UI

T.MenuSeparator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: UI.Size.pixel2
    verticalPadding: padding

    contentItem: Rectangle {
        radius: UI.Size.pixel6
        implicitWidth: 188
        implicitHeight: 1
        antialiasing: true
		color: UI.Theme.text.secondary
    }
}
