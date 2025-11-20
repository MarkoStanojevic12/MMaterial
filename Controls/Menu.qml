pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T

import MMaterial.UI as UI
import MMaterial.Media as Media

T.Menu {
    id: control

    property UI.ThemeBase theme: UI.Theme.currentTheme
    property color color: control.highlighted ? control.theme.text.primary : control.theme.text.secondary
    property string iconColor: Qt.color(control.color)
    property Media.IconData iconData: null
    property bool useIcons: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 0
	overlap: 1

    delegate: MenuItem {
        id: menuDelegate

        height: UI.Size.pixel36

        Component.onCompleted: {
            if (menuDelegate.subMenu) {
                menuDelegate.iconData = menuDelegate.subMenu.iconData
                menuDelegate.iconColor = menuDelegate.subMenu.iconColor
                menuDelegate.useIcons = menuDelegate.subMenu.useIcons
                menuDelegate.color = menuDelegate.subMenu.color
                menuDelegate.theme = menuDelegate.subMenu.theme
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    contentItem: Item {
        id: contentItemRoot

		implicitHeight: listView.implicitHeight + UI.Size.pixel8

        ListView {
            id: listView

            anchors.centerIn: contentItemRoot
            implicitHeight: contentHeight
            width: contentItemRoot.width
            model: control.contentModel
            spacing: 0
            interactive: Window.window
                         ? contentHeight + control.topPadding + control.bottomPadding > control.height
                         : false
            clip: true
            currentIndex: control.currentIndex
        }
    }

    background: Rectangle {
		radius: UI.Size.pixel12
        implicitWidth:  UI.Size.scale * 320
        implicitHeight: UI.Size.pixel36
		color: UI.Theme.background.paper

        border {
			color:  UI.Theme.other.divider
			width: 0.5
        }
    }

    T.Overlay.modal: Rectangle {
        color: Qt.alpha(control.palette.shadow, 0.5)
    }

    T.Overlay.modeless: Rectangle {
        color: Qt.alpha(control.palette.shadow, 0.12)
    }
}
