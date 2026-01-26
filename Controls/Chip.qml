import QtQuick

import MMaterial.UI as UI
import MMaterial.Media as Media

MFabButton {
	id: root

	property alias xButton: xButton

	size: UI.Size.Grade.S
	text: "Chip"
	accent: UI.Theme.primary
	type: MButton.Type.Soft
	radius: height / 3

	mouseArea {
		enabled: false
		visible: false
		hoverEnabled: false
	}

	Media.Icon {
		id: xButton

		interactive: true
		iconData: Media.Icons.light.cancel
		size: UI.Size.pixel14
		color: root.accent.main
	}
}
