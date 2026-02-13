import QtQuick
import MMaterial.UI as UI
import QtQuick.Shapes

Item {
    id: root

    property alias titleLabel: titleText
    property alias subtitleLabel: subtitleText

    property bool show: false
    property point startPoint: Qt.point(40, 40)

    property bool toRight: true
    property real lineLength: UI.Size.scale * 220
    property real quirkLength: UI.Size.pixel12
    property bool quirkUp: true

    property color dotColor: UI.Theme.secondary.light
    property color lineColor: UI.Theme.secondary.light

    property real dotDiameter: UI.Size.pixel10
    property real lineWidth: 2

    property string title: "Title"
    property string subtitle: ""

    property int dotDurationMs: 180
    property int lineDurationMs: 420
    property int quirkDurationMs: 140
    property int textDurationMs: 220
    property int easingType: Easing.InOutCubic

    property real textGap: UI.Size.pixel8

    readonly property point endPoint: Qt.point(startPoint.x + (toRight ? lineLength : -lineLength),
                                               startPoint.y)

    property real dotT: 0.0
    property real lineT: 0.0
    property real quirkT: 0.0
    property real textT: 0.0

    property real transitionOverlap: 70

    states: [
        State {
            id: stateHidden
            name: "hidden"
            when: !root.show
            PropertyChanges { id: pcHidden; target: root; dotT: 0.0; lineT: 0.0; quirkT: 0.0; textT: 0.0 }
        },
        State {
            id: stateShown
            name: "shown"
            when: root.show
            PropertyChanges { id: pcShown; target: root; dotT: 1.0; lineT: 1.0; quirkT: 1.0; textT: 1.0 }
        }
    ]

    transitions: [
        Transition {
            id: transitionShow
            from: "hidden"
            to: "shown"

            ParallelAnimation {
                id: paShow

                SequentialAnimation {
                    id: saShowDot
                    NumberAnimation {
                        id: naShowDot
                        target: root; property: "dotT"
                        from: 0.0; to: 1.0
                        duration: root.dotDurationMs
                        easing.type: Easing.OutCubic
                    }
                }

                SequentialAnimation {
                    id: saShowLine
                    PauseAnimation { id: paShowLinePause; duration: Math.max(0, root.dotDurationMs - root.transitionOverlap) }
                    NumberAnimation {
                        id: naShowLine
                        target: root; property: "lineT"
                        from: 0.0; to: 1.0
                        duration: root.lineDurationMs
                        easing.type: Easing.OutCubic
                    }
                }

                SequentialAnimation {
                    id: saShowQuirk
                    PauseAnimation { id: paShowQuirkPause; duration: Math.max(0, root.dotDurationMs + root.lineDurationMs - 2 * root.transitionOverlap) }
                    NumberAnimation {
                        id: naShowQuirk
                        target: root; property: "quirkT"
                        from: 0.0; to: 1.0
                        duration: root.quirkDurationMs
                        easing.type: Easing.OutCubic
                    }
                }

                SequentialAnimation {
                    id: saShowText
                    PauseAnimation { id: paShowTextPause; duration: Math.max(0, root.dotDurationMs + root.lineDurationMs + root.quirkDurationMs - 3 * root.transitionOverlap) }
                    NumberAnimation {
                        id: naShowText
                        target: root; property: "textT"
                        from: 0.0; to: 1.0
                        duration: root.textDurationMs
                        easing.type: Easing.OutCubic
                    }
                }
            }
        },

        Transition {
            id: transitionHide
            from: "shown"
            to: "hidden"

            ParallelAnimation {
                id: paHide

                SequentialAnimation {
                    id: saHideText
                    NumberAnimation {
                        id: naHideText
                        target: root; property: "textT"
                        from: 1.0; to: 0.0
                        duration: root.textDurationMs
                        easing.type: Easing.InCubic
                    }
                }

                SequentialAnimation {
                    id: saHideQuirk
                    PauseAnimation { id: paHideQuirkPause; duration: Math.max(0, root.textDurationMs - root.transitionOverlap) }
                    NumberAnimation {
                        id: naHideQuirk
                        target: root; property: "quirkT"
                        from: 1.0; to: 0.0
                        duration: root.quirkDurationMs
                        easing.type: Easing.InCubic
                    }
                }

                SequentialAnimation {
                    id: saHideLine
                    PauseAnimation { id: paHideLinePause; duration: Math.max(0, root.textDurationMs + root.quirkDurationMs - 2 * root.transitionOverlap) }
                    NumberAnimation {
                        id: naHideLine
                        target: root; property: "lineT"
                        from: 1.0; to: 0.0
                        duration: root.lineDurationMs
                        easing.type: Easing.InCubic
                    }
                }

                SequentialAnimation {
                    id: saHideDot
                    PauseAnimation { id: paHideDotPause; duration: Math.max(0, root.textDurationMs + root.quirkDurationMs + root.lineDurationMs - 3 * root.transitionOverlap) }
                    NumberAnimation {
                        id: naHideDot
                        target: root; property: "dotT"
                        from: 1.0; to: 0.0
                        duration: root.dotDurationMs
                        easing.type: Easing.InCubic
                    }
                }
            }
        }
    ]

    Rectangle {
        id: dot

        width: root.dotDiameter
        height: root.dotDiameter
        radius: root.dotDiameter / 2
        color: root.dotColor

        x: root.startPoint.x - width / 2
        y: root.startPoint.y - height / 2

        opacity: root.dotT
        scale: 0.6 + 0.4 * root.dotT
        transformOrigin: Item.Center
        antialiasing: true
    }

    Rectangle {
        id: lineRect
        color: root.lineColor
        height: root.lineWidth
        radius: height / 2
        antialiasing: true
        visible: root.lineT > 0.0
        opacity: root.lineT

        width: Math.max(0, root.lineLength * root.lineT)

        x: root.toRight
           ? root.startPoint.x
           : (root.startPoint.x - width)

        y: root.startPoint.y - height / 2
    }

    Shape {
        id: quirkShape
        visible: root.quirkT > 0.0
        opacity: root.quirkT

        width: Math.max(Math.max(root.startPoint.x, root.endPoint.x) + Math.abs(root.quirkLength) + 32, 1)
        height: Math.max(root.startPoint.y + Math.abs(root.quirkLength) + 32, 1)

        ShapePath {
            id: quirkPath

            readonly property real d: (root.quirkLength / Math.sqrt(2)) * root.quirkT

            strokeColor: root.lineColor
            strokeWidth: root.lineWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap


            startX: root.endPoint.x
            startY: root.endPoint.y

            PathLine {
                id: quirkLine
                x: root.endPoint.x + (root.toRight ? quirkPath.d : -quirkPath.d)
                y: root.endPoint.y + (root.quirkUp ? -quirkPath.d : quirkPath.d)
            }
        }
    }

    Item {
        id: textAnchor

        y: root.endPoint.y - textBlock.implicitHeight - root.textGap
        x: root.toRight ? (root.endPoint.x - textBlock.width) : root.endPoint.x

        opacity: root.textT
        transform: Translate { id: textTranslate; y: (1.0 - root.textT) * 6 }

        Column {
            id: textBlock
            spacing: 2
            width: root.lineLength

            UI.H6 {
                id: titleText
                text: root.title
                font.weight: Font.DemiBold
                visible: root.title.length > 0
                width: textBlock.width
                horizontalAlignment: root.toRight ? Text.AlignRight : Text.AlignLeft
            }

            UI.Subtitle2 {
                id: subtitleText
                text: root.subtitle
                color: UI.Theme.text.secondary
                opacity: 0.9
                visible: root.subtitle.length > 0
                width: textBlock.width
                wrapMode: Text.WordWrap
                horizontalAlignment: root.toRight ? Text.AlignRight : Text.AlignLeft
            }
        }
    }
}
