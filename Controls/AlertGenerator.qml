pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material

import MMaterial.UI as UI
import MMaterial.Controls as Controls

Popup {
    id: _root

	objectName: "default" // Preferably set this to a unique name for each instance of the component

    property int edgeOf: Item.TopLeft //TopRight, BottomLeft, BottomRight
    property int defaultVariant: Alert.Variant.Standard

    // The window's safe area (a phone's status and navigation bars, a notch): the overlay covers
    // the whole window, so the alerts keep this far from its edges on top of the 20 px gap
    property real safeMarginTop: _root.windowSafeArea ? _root.windowSafeArea.margins.top : 0
    property real safeMarginBottom: _root.windowSafeArea ? _root.windowSafeArea.margins.bottom : 0
    property real safeMarginLeft: _root.windowSafeArea ? _root.windowSafeArea.margins.left : 0
    property real safeMarginRight: _root.windowSafeArea ? _root.windowSafeArea.margins.right : 0

    readonly property var windowSafeArea: Overlay.overlay && Overlay.overlay.Window.contentItem
                                          ? Overlay.overlay.Window.contentItem.SafeArea : null

    x: _root.edgeOf === Item.TopLeft || _root.edgeOf === Item.BottomLeft || _root.edgeOf === Item.Left
       ? 20 + _root.safeMarginLeft : Overlay.overlay.width - 20 - _root.safeMarginRight - width
    y: _root.edgeOf === Item.TopLeft || _root.edgeOf === Item.TopRight || _root.edgeOf === Item.Top
       ? 20 + _root.safeMarginTop : Overlay.overlay.height - 20 - _root.safeMarginBottom - height

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

            property var item: listModel.get(index)
            property int closeTime: item ? item.closeTime : 0

            width: _contentRoot.width

            text: item && item.text ? item.text : ""
            severity: item && item.severity ? item.severity : severity
            variant: item && item.variant ? item.variant : _root.defaultVariant

            dismissButton {
                text: item && item.dismissButton && item.dismissButton.text ? item.dismissButton.text : dismissButton.text
                onClicked: item && item.dismissButton && item.dismissButton.onClicked ? item.dismissButton.onClicked() : function(){
                    _alertComponent.close();
                }
            }

            actionButton {
                text: item && item.actionButton && item.actionButton.text && item.actionButton.text ? item.actionButton.text : actionButton.text
                onClicked: item && item.actionButton && item.actionButton.onClicked ? item.actionButton.onClicked() : null
            }

            onClose: listModel.remove(index)

            Timer {
                id: _timer

                running: _root.visible
                interval: _alertComponent.closeTime

                onTriggered: {
                    if(_alertComponent.index >= 0)
                        listModel.remove(_alertComponent.index)
                }
            }
        }

        add: Transition {
            NumberAnimation { properties: "x"; from: d.horizontalDirection == Item.Left ? -_contentRoot.width : _contentRoot.width; duration: 500; easing.type: Easing.OutBack }
        }
        remove: Transition { 
            NumberAnimation { properties: "x"; to: d.horizontalDirection == Item.Left ? -_contentRoot.width : _contentRoot.width; duration: 500; easing.type: Easing.OutBack } 
        }
        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.OutBack }
        }
    }

    QtObject {
        id: d

        property int horizontalDirection: _root.edgeOf === Item.TopLeft || _root.edgeOf === Item.BottomLeft || _root.edgeOf === Item.Left ? Item.Left : Item.Right
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
				text : message,
				closeTime : duration
			};

			if(details.severity)
				alertObject.severity = details.severity;
			if(details.icon)
				alertObject.icon = details.icon;
			if(details.variant)
				alertObject.variant = details.variant;
			if(details.dismissButton)
				alertObject.dismissButton = details.dismissButton;
			if(details.actionButton)
				alertObject.actionButton = details.actionButton;

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




