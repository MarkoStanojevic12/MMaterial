import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T

import MMaterial.Controls as Controls

T.ScrollView {
	id: control

	implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
							contentWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
							 contentHeight + topPadding + bottomPadding)

	Controls.ScrollBar.vertical: Controls.ScrollBar {
		parent: control
		x: control.mirrored ? 0 : control.width - width
		y: control.topPadding
		height: control.availableHeight
		active: control.ScrollBar.horizontal.active
	}

	Controls.ScrollBar.horizontal: Controls.ScrollBar {
		parent: control
		x: control.leftPadding
		y: control.height - height
		width: control.availableWidth
		active: control.ScrollBar.vertical.active
	}
}
