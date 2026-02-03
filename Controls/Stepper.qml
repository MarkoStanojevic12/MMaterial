import QtQuick
import QtQuick.Layouts

import MMaterial.Media as Media
import MMaterial.UI as UI

ListView {
    id: stepper

    property real delegateWidth: stepper.orientation == ListView.Horizontal ? UI.Size.scale * 300 : stepper.width

    function nextStep() : void {
        stepper.incrementCurrentIndex()
    }

    function previousStep() : void {
        stepper.decrementCurrentIndex()
    }

    implicitWidth: parent.width
    implicitHeight: orientation == ListView.Horizontal ? UI.Size.pixel64 : contentHeight

    clip: true
    spacing: UI.Size.pixel8
    currentIndex: 0
    orientation: ListView.Horizontal
    interactive: false

    model: [
        { title: "Select a sample", subtitle: "Choose a material to inspect and compare." },
        { title: "Capture photos", subtitle: "Take a few shots under consistent lighting." },
        { title: "Adjust parameters", subtitle: "Tune roughness, metallic and base color." },
        { title: "Preview in 3D", subtitle: "Rotate the model to verify highlights and shadows." },
        { title: "Export results", subtitle: "Save textures and settings for your pipeline." }
    ]

    delegate: Rectangle {
        id: step

        required property int index
        required property string title
        required property string subtitle

        width: stepper.orientation == ListView.Horizontal ? stepper.delegateWidth : stepper.width
        height: UI.Size.pixel64
        radius: UI.Size.pixel10
        color: UI.Theme.background.paper

        RowLayout {
            spacing: UI.Size.pixel12

            anchors {
                fill: parent
                margins: UI.Size.pixel12
            }

            Rectangle {
                id: stepIcon

                height: UI.Size.pixel40
                width: height
                radius: height / 2

                color: UI.Theme.secondary.main

                states: [
                    State {
                        name: "active"
                        when: index === stepper.currentIndex

                        PropertyChanges { target: stepIcon; color: UI.Theme.secondary.main }
                        PropertyChanges { target: stepIndexLabel; scale: 1 }
                        PropertyChanges { target: checkIcon; scale: 0 }
                        PropertyChanges { target: titleLabel; color: UI.Theme.text.primary }
                        PropertyChanges { target: subtitleLabel; color: UI.Theme.text.primary }
                    },
                    State {
                        name: "completed"
                        when: index < stepper.currentIndex

                        PropertyChanges { target: stepIcon; color: UI.Theme.success.main }
                        PropertyChanges { target: stepIndexLabel; scale: 0 }
                        PropertyChanges { target: checkIcon; scale: 1 }
                    },
                    State {
                        name: "inactive"
                        when: index > stepper.currentIndex

                        PropertyChanges { target: stepIcon; color: UI.Theme.passive.main }
                        PropertyChanges { target: stepIndexLabel; scale: 1 }
                        PropertyChanges { target: checkIcon; scale: 0 }
                    }
                ]

                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 400 }
                    NumberAnimation { properties: "scale"; duration: 400; easing.type: Easing.OutQuad }
                }

                UI.H6 {
                    id: stepIndexLabel

                    anchors.centerIn: stepIcon
                    lineHeight: 1
                    text: index + 1
                    visible: scale > 0
                }

                Media.Icon {
                    id: checkIcon

                    anchors.centerIn: stepIcon
                    iconData: Media.Icons.light.check
                    visible: scale > 0
                    size: UI.Size.pixel24
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: UI.Size.pixel2

                UI.Subtitle1 {
                    id: titleLabel

                    Layout.fillWidth: true
                    text: title
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    wrapMode: Text.NoWrap
                    color: UI.Theme.text.secondary
                }

                UI.B2 {
                    id: subtitleLabel

                    Layout.fillWidth: true
                    text: subtitle
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    wrapMode: Text.NoWrap
                    color: UI.Theme.text.secondary
                }
            }
        }
    }
}
