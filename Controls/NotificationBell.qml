import QtQuick

import MMaterial.UI as UI
import MMaterial.Media as Media
import MMaterial.Controls as Controls

Item {
    id: _root

    property alias icon: _icon
    property alias badge: _badge
    property alias popup: _popup

    implicitWidth: _icon.size + UI.Size.pixel8
    implicitHeight: implicitWidth

    Media.Icon {
        id: _icon

        anchors.centerIn: _root
        iconData: Media.Icons.light.notifications
        color: UI.Theme.text.secondary.toString()
        size: UI.Size.pixel24
        interactive: true

        onClicked: _popup.opened ? _popup.close() : _popup.open()
    }

    Controls.BadgeNumber {
        id: _badge

        visible: Controls.NotificationCenter.unreadCount > 0
        quantity: Controls.NotificationCenter.unreadCount
        maxQuantity: 99
        pixelSize: UI.Size.pixel10

        anchors {
            top: _root.top
            right: _root.right
        }
    }

    Controls.NotificationCenterPopup {
        id: _popup

        parent: _root
        x: _root.width - width
        y: _root.height + UI.Size.pixel8
    }
}
