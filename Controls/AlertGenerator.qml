pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material

import MMaterial.UI as UI
import MMaterial.Controls as Controls

Popup {
    id: _root

    objectName: "default" // Preferably set this to a unique name for each instance of the component

    property int edgeOf: Item.TopLeft //TopRight, BottomLeft, BottomRight, Top, Bottom
    property int defaultVariant: Alert.Variant.Standard

    property real horizontalMargin: UI.Size.pixel20
    property real verticalMargin: UI.Size.pixel20

    x: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom)
       ? (Overlay.overlay.width - width) / 2
       : (_root.edgeOf === Item.TopLeft || _root.edgeOf === Item.BottomLeft || _root.edgeOf === Item.Left ? horizontalMargin : Overlay.overlay.width - horizontalMargin - width)

    y: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom)
       ? (_root.edgeOf === Item.Top ? verticalMargin : Overlay.overlay.height - verticalMargin - height)
       : (_root.edgeOf === Item.TopLeft || _root.edgeOf === Item.TopRight || _root.edgeOf === Item.Top ? verticalMargin : Overlay.overlay.height - verticalMargin - height)

    enter: null

    parent: Overlay.overlay
    modal: false
    dim: false
    closePolicy: Popup.NoAutoClose
    visible: listModel.count > 0

    Component.onCompleted: Controls.AlertController.subscribe(_root.objectName);

    background: Item {}
    contentItem: ListView {
        id: _contentRoot

        implicitWidth: 300
        implicitHeight: Math.max(contentHeight, UI.Size.pixel48)

        verticalLayoutDirection: d.verticalDirection == Item.Top ? ListView.TopToBottom : ListView.BottomToTop
        spacing: UI.Size.pixel4
        interactive: false

        model: ListModel {
            id: listModel
        }

        delegate: Alert {
            id: _alertComponent

            required property int index
            required property string alertText
            required property var details

            required property int closeTime

            width: _contentRoot.width

            text: _alertComponent.alertText
            severity: _alertComponent.details !== undefined && _alertComponent.details.severity !== undefined ? _alertComponent.details.severity : severity
            variant: _alertComponent.details !== undefined && _alertComponent.details.variant !== undefined ? _alertComponent.details.variant : _root.defaultVariant

            dismissButton {
                text: _alertComponent.details !== undefined && _alertComponent.details.dismissButton !== undefined && _alertComponent.details.dismissButton.text !== undefined ? _alertComponent.details.dismissButton.text : dismissButton.text
                onClicked: {
                    if (_alertComponent.details !== undefined && _alertComponent.details.dismissButton !== undefined && _alertComponent.details.dismissButton.onClicked !== undefined)
                    _alertComponent.details.dismissButton.onClicked()
                    _alertComponent.close();
                }
            }

            actionButton {
                text: _alertComponent.details !== undefined && _alertComponent.details.actionButton !== undefined && _alertComponent.details.actionButton.text !== undefined ? _alertComponent.details.actionButton.text : actionButton.text
                onClicked: {
                    if (_alertComponent.details !== undefined && _alertComponent.details.actionButton !== undefined && _alertComponent.details.actionButton.onClicked !== undefined)
                    _alertComponent.details.actionButton.onClicked();
                    _alertComponent.close();
                }
            }

            onClose: listModel.remove(index)

            Timer {
                id: _timer

                running: _root.visible && _alertComponent.closeTime > 0
                interval: _alertComponent.closeTime

                onTriggered: {
                    if(_alertComponent.index >= 0)
                    listModel.remove(_alertComponent.index)
                }
            }
        }

        add: Transition {
            NumberAnimation {
                properties: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom) ? "y" : "x"
                from: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom)
                      ? (d.verticalDirection == Item.Top ? -_contentRoot.height : _contentRoot.height)
                      : (d.horizontalDirection == Item.Left ? -_contentRoot.width : _contentRoot.width)
                duration: 500
                easing.type: Easing.OutBack
            }
        }

        remove: Transition {
            NumberAnimation {
                properties: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom) ? "y" : "x"
                to: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom)
                    ? (d.verticalDirection == Item.Top ? -_contentRoot.height : _contentRoot.height)
                    : (d.horizontalDirection == Item.Left ? -_contentRoot.width : _contentRoot.width)
                duration: 500
                easing.type: Easing.OutBack
            }
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.OutBack }
        }
    }

    QtObject {
        id: d

        property int horizontalDirection: (_root.edgeOf === Item.Top || _root.edgeOf === Item.Bottom)
                                          ? Item.Left
                                          : (_root.edgeOf === Item.TopLeft || _root.edgeOf === Item.BottomLeft || _root.edgeOf === Item.Left ? Item.Left : Item.Right)
        property int verticalDirection: _root.edgeOf === Item.TopLeft || _root.edgeOf === Item.TopRight || _root.edgeOf === Item.Top ? Item.Top : Item.Bottom
        property AlertController alertController: AlertController

        function activate(
            message,
            details = {},
            duration = 3500)
        {
            if(!message)
                console.warn("No text added for alert!")

            let alertObject = {
                alertText : message,
                closeTime : duration,
                details : details
            };

            _contentRoot.model.append(alertObject);
        }
    }

    Connections {
        target: Controls.AlertController

        function onAlert (message, details, duration, objectName): void {
            if (objectName === _root.objectName || objectName === "") {
                d.activate(message, details, duration);
            }
        }
    }
}
