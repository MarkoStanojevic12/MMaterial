import QtQuick

Tour {
    id: root

    property alias target: singleStep.target
    property alias title: singleStep.title
    property alias description: singleStep.description
    property alias allowInteraction: singleStep.allowInteraction
    property alias side: singleStep.side

    function show() {
        root.start(0);
    }

    function hide() {
        root.abort();
    }

    steps: [
        TourStep {
            id: singleStep
        }
    ]
}
