import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

import MMaterial.UI as UI

T.ScrollIndicator {
	id: root

	property color color: UI.Theme.action.active

	implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
							implicitContentWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
							 implicitContentHeight + topPadding + bottomPadding)

	contentItem: Rectangle {
		implicitWidth: UI.Size.pixel4
		implicitHeight: UI.Size.pixel4

		radius: width / 2
		color: root.color
		visible: root.size < 1.0
		opacity: 0.0

		states: State {
			name: "active"
			when: root.active
			PropertyChanges { root.contentItem.opacity: 0.75 }
		}

		transitions: [
			Transition {
				from: "active"
				SequentialAnimation {
					PauseAnimation { duration: 450 }
					NumberAnimation { target: root.contentItem; duration: 200; property: "opacity"; to: 0.0 }
				}
			}
		]
	}
}
