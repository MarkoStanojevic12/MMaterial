import QtQuick
import QtQuick.Templates as T

import MMaterial.UI as UI
import MMaterial.Media as Media

T.TextField {
	id: root

	property alias leftIcon: _leftIcon
	property alias rightIcon: _rightIcon
	property alias ignoreDisabledColoring: bg.ignoreDisabledColoring

	property UI.ThemeBase theme: UI.Theme.currentTheme
	property UI.PaletteBasic accent: root.theme.primary
	property UI.PaletteBasic errorAccent: root.theme.error

	property real horizontalMargins: UI.Size.pixel12
	property bool showPlaceholder: !root.activeFocus && root.text === ""
	property int type: TextField.Type.Standard
	property bool forceErrorState: false

	enum Type { Filled, Outlined, Standard }

	implicitHeight: 48 * UI.Size.scale
	implicitWidth: (UI.Size.format == UI.Size.Format.Extended ? 319 : 200) * UI.Size.scale

	verticalAlignment: Qt.AlignVCenter
	selectByMouse: true
	selectedTextColor: acceptableInput ? root.accent.contrastText : root.errorAccent.contrastText
	selectionColor: acceptableInput ? root.accent.main : root.errorAccent.main
	placeholderTextColor: root.theme.text.primary

	leftPadding: (d.isStandardType ? 0 : d.horizontalPadding) + (leftIcon.visible ? leftIcon.width + UI.Size.pixel8 : 0)
	rightPadding: d.horizontalPadding + (rightIcon.visible ? rightIcon.width + UI.Size.pixel8 : 0)
	topPadding:  d.isFilledType ? root.height * 0.3 : (d.isStandardType ? root.height * 0.4 : UI.Size.pixel2)

	font {
		family: UI.Font.normal
		pixelSize: UI.Size.pixel14
	}

	QtObject{
		id: d

		readonly property real horizontalPadding: root.height / 4

		property bool isOutlinedType: root.type == TextField.Type.Outlined
		property bool isFilledType: root.type == TextField.Type.Filled
		property bool isStandardType: !isFilledType && !isOutlinedType
	}

	Item {
		id: _mainContainer

		anchors {
			fill: root
			topMargin: root.type === TextField.Type.Outlined ? 0 : (root.activeFocus ? UI.Size.pixel16 : 0)
		}

		Media.Icon {
			id: _leftIcon

			anchors {
				left: _mainContainer.left; leftMargin: d.isStandardType ? 0 : d.horizontalPadding;
				verticalCenter: _mainContainer.verticalCenter
			}

			color: root.theme.text.disabled.toString()
			visible: iconData
			size: !visible ? 0 : bg.height * 0.3
		}

		Media.Icon {
			id: _rightIcon

			anchors {
				right: _mainContainer.right; rightMargin: UI.Size.pixel12;
				verticalCenter: _mainContainer.verticalCenter
			}

			color: root.theme.action.active.toString()
			visible: iconData
			interactive: true
			size: !visible ? 0 : bg.height * 0.3
		}
	}

	background: InputsBackground {
		id: bg

		theme: root.theme
		rootItem: root
		showPlaceholder: root.showPlaceholder
		leftIcon: _leftIcon
		iconContainer: _mainContainer
		errorAccent: root.errorAccent
		acceptableInput: root.acceptableInput && !root.forceErrorState
	}
}
