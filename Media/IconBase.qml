import QtQuick

import MMaterial.Media as Media
import MMaterial.UI as UI

Item {
    id: _root

    property Media.IconData iconData

    property real size: UI.Size.pixel20

    property string color: ""
    property bool interactive: false
    property bool hoverable: false
    property bool containsMouse: _root.hoverable ? hoverHandler.hovered : false

    signal clicked

    implicitHeight: size
    implicitWidth: size

    states: [
        State {
            when: tapHandler.pressed && _root.interactive
            name: "pressed"
            PropertyChanges { target: _root; scale: 0.8; }
        },
        State {
            when: _root.interactive
            name: "default"
            PropertyChanges { target: _root; scale: 1; }
        }
    ]

    transitions: [
        Transition {
            from: "pressed"
            NumberAnimation { id: _clickedAnimation; target: _root; properties: "scale"; duration: 1150; easing.type: Easing.OutElastic; }
        },
        Transition {
            from: "default"
            NumberAnimation { target: _root; properties: "scale"; duration: 70; }
        }
    ]

    TapHandler {
        id: tapHandler

        enabled: _root.interactive
        cursorShape: containsMouse && _root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor

        onTapped: if(_root.interactive){ _root.clicked(); }
    }

    Item {
        height: _root.hoverable ? _root.height : 0
        width: _root.hoverable ? _root.width : 0

        HoverHandler {
            id: hoverHandler

            enabled: _root.hoverable
            grabPermissions: PointerHandler.CanTakeOverFromAnything
            cursorShape: hovered && _root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        }
    }

}
