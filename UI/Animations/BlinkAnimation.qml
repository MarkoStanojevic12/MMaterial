import QtQuick

SequentialAnimation {
	id: root

	required property Item target
	property real durationMultiplier: 1

	running: root.target.visible
	loops: Animation.Infinite

	NumberAnimation {
		target: root.target
		property: "opacity"
		from: 1.0
		to: 0.15
		duration: 400 * durationMultiplier
	}

	NumberAnimation {
		target: root.target
		property: "opacity"
		from: 0.15
		to: 1.0
		duration: 800 * durationMultiplier
	}

	PauseAnimation {
		duration: 200
	}
}
