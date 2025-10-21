import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

import MMaterial.UI as UI
import MMaterial.Media as Media

T.MenuItem {
    id: control

    property UI.ThemeBase theme: UI.Theme.currentTheme
    property color color: control.highlighted ? control.theme.text.primary : control.theme.text.secondary
	property Media.IconData iconData: null
	property bool useIcons: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: UI.Size.pixel6
    spacing: UI.Size.pixel16
	horizontalPadding: UI.Size.pixel8

    icon {
        height: UI.Size.pixel22
        width: UI.Size.pixel22
        color: control.color
    }

    font {
        family: UI.Font.normal
        pixelSize: UI.Size.pixel14
    }

    contentItem: Item {
        id: contentItemRoot

        opacity: control.enabled ? 1.0 : 0.48

        RowLayout {
			spacing: control.spacing

            anchors {
                fill: contentItemRoot
				rightMargin: control.indicator.visible || control.arrow.visible ? control.icon.width + control.rightPadding * 2 : 0
				leftMargin: control.useIcons ? 0 : control.horizontalPadding
            }

			Media.Icon {
				id: contentIcon

				Layout.leftMargin: UI.Size.pixel8

                size: control.icon.height
                iconData: control.iconData
				visible: control.useIcons
				color: Qt.color(control.color)
            }

			UI.B2 {
                Layout.fillHeight: true
                Layout.fillWidth: true

                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                maximumLineCount: 1
                color: control.color
                text: control.text
                font: control.font
            }
        }
    }

	indicator: MCheckbox {
		implicitHeight: UI.Size.pixel20
		implicitWidth: UI.Size.pixel20

		x: control.mirrored ? control.leftPadding : control.width - width - control.horizontalPadding * 2
		y: control.topPadding + (control.availableHeight - height) / 2

        theme: control.theme
		visible: control.checkable
		checked: control.checked
		customCheckImplementation: true

        onClicked: {
            control.checked = !control.checked
            control.toggled()
        }
    }

	arrow: Media.Icon {
        x: control.mirrored ? control.leftPadding : control.width - width - control.padding * 2
        y: control.topPadding + (control.availableHeight - height) / 2

		size: control.icon.height
		visible: control.subMenu && !control.checkable
		iconData: control.subMenu ? Media.Icons.light.chevronRight : null
		color: Qt.color(control.color)
    }

    background: Rectangle {
        implicitHeight: UI.Size.pixel36
		x: UI.Size.pixel4
		width: control.width - UI.Size.pixel8
        height: control.height - 2
        radius: UI.Size.pixel6
        color: control.down ? control.theme.action.selected : control.highlighted || checkableMA.containsMouse ? control.theme.action.hover : "transparent"
    }

	MouseArea {
		id: checkableMA

		anchors.fill: control
		hoverEnabled: enabled
		visible: control.checkable
		enabled: control.enabled && control.checkable

		onClicked: {
			control.checked = !control.checked
            control.toggled()
		}
	}
}
