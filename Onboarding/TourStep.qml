import QtQuick

QtObject {
    enum Side {
        Auto,
        Top,
        Bottom,
        Left,
        Right
    }

    property Item target
    property Item unionTarget
    property string title
    property string description

    property bool enabled: true
    property bool centered: false
    property bool autoScroll: true
    property bool allowInteraction: false
    property bool nextButtonVisible: true
    property bool backButtonVisible: true
    property string skipButtonText: ""
    property int side: TourStep.Side.Auto
    property real padding: -1
    property real radius: -1

    signal entered()
    signal skipClicked()
}
