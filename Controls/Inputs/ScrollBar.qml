import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T

T.ScrollBar {
	id: control

	implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
							implicitContentWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
							 implicitContentHeight + topPadding + bottomPadding)

	padding: 2
	visible: control.policy !== T.ScrollBar.AlwaysOff
	minimumSize: orientation === Qt.Horizontal ? height / width : width / height

	contentItem: Rectangle {
		implicitWidth: control.interactive ? 6 : 2
		implicitHeight: control.interactive ? 6 : 2

		radius: width / 2
		color: control.pressed ? control.palette.dark : control.palette.mid
		opacity: 0.0

		states: State {
			name: "active"
			when: control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
			PropertyChanges { control.contentItem.opacity: 0.75 }
		}

		transitions: Transition {
			from: "active"
			SequentialAnimation {
				PauseAnimation { duration: 450 }
				NumberAnimation { target: control.contentItem; duration: 200; property: "opacity"; to: 0.0 }
			}
		}
	}
}
