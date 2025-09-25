import QtQuick

QtObject {
    enum RenderType { Heavy, Light }

    property string path
    property int type
    property real brightness: 0.7
    property real colorization: 1
}
