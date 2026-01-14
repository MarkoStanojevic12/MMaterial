import QtQuick
import MMaterial.UI

Item {
    id: root

    property int batteryPercentage: 20
    property bool isCharging: false
    property color batteryColor: root.batteryPercentage > 50
                         ? Theme.success.main
                         : root.batteryPercentage > 20
                           ? Theme.warning.main
                           : Theme.error.main

    height: Size.pixel12
    width: Size.pixel22

    anchors {
        centerIn: parent
        verticalCenterOffset: -Size.pixel40
    }

    NumberAnimation {
        target: d
        properties: "displayBatteryPercentage"
        from: 0
        to: 100
        duration: 2000
        easing.type: Easing.InOutQuad
        loops: Animation.Infinite
        running: root.isCharging
    }

    QtObject {
        id: d

        property int displayBatteryPercentage: 0
    }

    Behavior on batteryColor {
        ColorAnimation {
            duration: 200
        }
    }

    Rectangle {
        id: outerRect

        radius: root.height / 4
        color: "transparent"
        width: Size.pixel20
        height: root.height

        border {
            width: Size.pixel2
            color: root.batteryColor
        }

        Item {
            id: innerRectFrame

            anchors {
                fill: outerRect
                margins: outerRect.height * 0.25
            }
        }

        Rectangle {
            id: innerRect

            radius: 0
            color: root.batteryColor

            anchors {
                fill: innerRectFrame
                rightMargin: innerRectFrame.width * (1 - (root.isCharging ? d.displayBatteryPercentage : root.batteryPercentage) / 100)
            }
        }
    }

    Rectangle {
        color: root.batteryColor
        height: outerRect.height * 0.5
        width: Size.pixel2

        topRightRadius: Size.pixel5
        bottomRightRadius: Size.pixel5

        anchors {
            left: outerRect.right
            leftMargin: innerRectFrame.anchors.margins / 3
            verticalCenter: outerRect.verticalCenter
        }
    }
}
