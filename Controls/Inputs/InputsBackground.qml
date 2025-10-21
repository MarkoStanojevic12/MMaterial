import QtQuick

import MMaterial.UI as UI
import MMaterial.Controls.Inputs as Inputs
import MMaterial.Media as Media

Rectangle {
	id: root

	required property var rootItem
	required property Media.Icon leftIcon
	required property Item iconContainer

	property UI.ThemeBase theme: UI.Theme.currentTheme
	property bool ignoreDisabledColoring: false
	property bool showPlaceholder: true
	property bool acceptableInput: rootItem.acceptableInput

	radius: UI.Size.pixel8

	border {
		width: root.rootItem.type === TextField.Type.Outlined ? 1 : 0
		color: root.theme.text.primary
	}

	states: [
		//Filled
		State {
			name: "disabled-filled"
			when: (!root.rootItem.enabled && !root.ignoreDisabledColoring) && root.rootItem.type == TextField.Type.Filled
			PropertyChanges { target: root; color: root.theme.action.disabledBackground; border { color: root.theme.action.disabledBackground } }
			PropertyChanges { target: root.rootItem; color: root.theme.text.disabled; placeholderTextColor: root.theme.text.disabled }
		},
		State {
			name: "error-filled"
			when: !root.acceptableInput && root.rootItem.type == TextField.Type.Filled && !(root.rootItem instanceof Inputs.TextArea)
			PropertyChanges { target: root; color: root.theme.error.transparent.p8; border { color: root.theme.error.main } }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.error.main }
		},
		State {
			name: "focused-filled"
			when: root.rootItem.focus && root.rootItem.type == TextField.Type.Filled
			PropertyChanges { target: root; color: root.theme.main.transparent.p16; border { color: root.theme.text.primary} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.primary }
		},
		State {
			name: "hovered-filled"
			when: root.rootItem.hovered && root.rootItem.type == TextField.Type.Filled
			PropertyChanges { target: root; color: root.theme.main.transparent.p16; border { color: root.theme.text.primary} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.disabled }
		},
		State {
			name: "normal-filled"
			when: root.rootItem.type == TextField.Type.Filled
			PropertyChanges { target: root; color: root.theme.main.transparent.p8; border { color: root.theme.action.disabledBackground} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.disabled }
		},

		//Outlined
		State {
			name: "disabled-outlined"
			when: (!root.rootItem.enabled && !root.ignoreDisabledColoring) && root.rootItem.type == TextField.Type.Outlined
			PropertyChanges { target: root; color: root.theme.background.paper; border { color: root.theme.action.disabledBackground } }
			PropertyChanges { target: root.rootItem; color: root.theme.text.disabled; placeholderTextColor: root.theme.text.disabled }
		},
		State {
			name: "error-outlined"
			when: !root.acceptableInput && root.rootItem.type == TextField.Type.Outlined && !(root.rootItem instanceof Inputs.TextArea)
			PropertyChanges { target: root; color: root.theme.background.paper; border { color: root.theme.error.main } }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.error.main }
		},
		State {
			name: "focused-outlined"
			when: root.rootItem.activeFocus && root.rootItem.type == TextField.Type.Outlined
			PropertyChanges { target: root; color: root.theme.background.paper; border { color: root.theme.text.primary} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.primary }
		},
		State {
			name: "hovered-outlined"
			when: root.rootItem.hovered && root.rootItem.type == TextField.Type.Outlined
			PropertyChanges { target: root; color: root.theme.background.paper; border { color: root.theme.text.primary} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.disabled }
		},
		State {
			name: "normal-outlined"
			when: root.rootItem.type == TextField.Type.Outlined
			PropertyChanges { target: root; color: root.theme.background.paper; border { color: root.theme.action.disabledBackground} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.disabled }
		},

		//Standard
		State {
			name: "disabled"
			when: (!root.rootItem.enabled && !root.ignoreDisabledColoring)
			PropertyChanges { target: root; color: "transparent"; border { color: root.theme.action.disabledBackground } }
			PropertyChanges { target: root.rootItem; color: root.theme.text.disabled; placeholderTextColor: root.theme.text.disabled }
		},
		State {
			name: "error"
			when: !root.acceptableInput && !(root.rootItem instanceof Inputs.TextArea)
			PropertyChanges { target: root; color: "transparent"; border { color: root.theme.error.main } }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.error.main }
		},
		State {
			name: "focused"
			when: root.rootItem.activeFocus
			PropertyChanges { target: root; color: "transparent"; border { color: root.theme.text.primary} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.primary }
		},
		State {
			name: "hovered"
			when: root.rootItem.hovered
			PropertyChanges { target: root; color: "transparent"; border { color: root.theme.text.primary} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.disabled }
		},
		State {
			name: "normal"
			when: true
			PropertyChanges { target: root; color: "transparent"; border { color: root.theme.action.disabledBackground} }
			PropertyChanges { target: root.rootItem; color: root.theme.text.primary; placeholderTextColor: root.theme.text.disabled }
		}
	]

	QtObject {
		id: d

		property real fontSize: 0

		Component.onCompleted: fontSize = root.rootItem.font.pixelSize
	}

	Rectangle {
		anchors.bottom: root.bottom

		width: root.width
		height: 1

		color: root.border.color
		visible: root.rootItem.type !== TextField.Type.Outlined && root.rootItem.type !== TextField.Type.Filled
	}

	Rectangle {
		id: _labelContainer

		scale: _label.scale

		height: root.border.width * 2
		width: _label.width
		visible: _label.text !== "" && root.rootItem.type === TextField.Outlined
		color: root.color
		radius: UI.Size.pixel8

		anchors {
			top: root.top
			left: _label.left
			right: _label.right
			leftMargin: -UI.Size.pixel4
			rightMargin: UI.Size.pixel4
		}
	}

	UI.B2 {
		id: _label

		verticalAlignment: Qt.AlignVCenter
		horizontalAlignment: root.type === Inputs.TextField.Type.Outlined ? Qt.AlignHCenter : Qt.AlignLeft

		width: Math.min(implicitWidth + UI.Size.pixel8, root.rootItem.width)
		height: implicitHeight

		font.pixelSize: root.rootItem.font.pixelSize
		text: root.rootItem.placeholderText
		color: root.rootItem.placeholderTextColor

		lineHeight: 1

		state: root.showPlaceholder ? "foreground" : "background"
		states: [
			State {
				name: "foreground"
				when: root.showPlaceholder
				PropertyChanges { target: _labelContainer; opacity: 0.0; }
				PropertyChanges { target: root.iconContainer; anchors { topMargin: 0; } }
				PropertyChanges{
					target: _label;
					font.pixelSize: d.fontSize
					opacity: root.acceptableInput ? 1 : 0.62
					y: {
						if (root.rootItem instanceof Inputs.TextArea) {
							if (root.rootItem.type == Inputs.TextField.Filled)
								return root.rootItem.topPadding / 2
							else
								return root.rootItem.topPadding
						}
						return root.rootItem.height / 2 - _label.height / 2
					}

					x: root.rootItem instanceof Inputs.ComboBox ?
						root.rootItem.leftPadding :
						root.rootItem instanceof Inputs.TextArea ? root.rootItem.leftPadding :
						(root.rootItem.type === Inputs.TextField.Type.Standard ?
							 (root.leftIcon.visible ? root.leftIcon.size / 2 + root.rootItem.leftPadding : 0) :
							 (root.leftIcon.visible ? (root.leftIcon.size / 2 + root.rootItem.leftPadding ) : root.rootItem.leftPadding))
				}
			},
			State {
				name: "background"
				when: true
				PropertyChanges { target: _labelContainer; opacity: 1.0; }
				PropertyChanges { target: root.iconContainer; anchors { topMargin: root.rootItem.type === TextField.Type.Outlined ? 0 : UI.Size.pixel16; } }
				PropertyChanges{
					target: _label;
					font.pixelSize: d.fontSize * 0.7
					x: root.rootItem.type === Inputs.TextField.Type.Standard ? 0 : root.rootItem.leftPadding - (root.leftIcon && root.leftIcon.visible ? root.leftIcon.width + UI.Size.pixel8 : 0)
					y: root.rootItem.type === Inputs.TextField.Type.Outlined ? -height/2 : height/2;
				}
			}
		]

		transitions: [
			Transition {
				NumberAnimation { properties: "x,y,font.pixelSize,opacity,anchors.topMargin"; duration: 100; easing.type: Easing.InOutQuad }
			}
		]
	}
}
