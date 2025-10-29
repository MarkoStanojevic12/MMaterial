import QtQuick

SequentialAnimation {
	id: root

	required property Item target

	running: root.target.visible
	loops: Animation.Infinite

	NumberAnimation {
		target: root.target
		property: "opacity"
		from: 0.15
		to: 1.0
		duration: 800
	}
	NumberAnimation {
		target: root.target
		property: "opacity"
		from: 1.0
		to: 0.15
		duration: 400
	}

	PauseAnimation {
		duration: 200
	}
}
