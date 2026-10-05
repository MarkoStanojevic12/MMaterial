import QtQuick
import QtQuick.Shapes

import MMaterial.UI

Shape {
	id: root

	property int size: 144
	property real peakWidth: -0.58       // 0 = narrow hill, 1 = wide hill
	property real subPeakWidth: -0.27    // 0 = sharp control points, 1 = wide pull
	property color color: Theme.background.paper

	// The y where the hill meets its base. Lay the shape over what it grows out of (a rectangle of the
	// same color) with this line on that rectangle's top edge: the hill's feet run flat into the edge,
	// so the two read as one shape at any size. Below the line the shape is a plain band.
	readonly property real baseY: d.ny(320)
	// The hill above baseY; center a label in it
	readonly property alias hill: hill

	width: root.size
	height: root.size * 62 / 144
	// Smooth curve edges, without multisampling
	preferredRendererType: Shape.CurveRenderer

	Item {
		id: hill

		width: root.width
		height: root.baseY
	}

	QtObject {
		id: d

		readonly property real controlSpread: 50

		readonly property real leftControl1X: 140
		readonly property real leftControl2X: 130
		readonly property real rightControl1X: 382
		readonly property real rightControl2X: 372

		function ny(y) {
			return root.height * ((y - 192) / 192);
		}

		function computeX(xBase, direction) {
			return root.width * (
				(xBase + direction * controlSpread * root.peakWidth * root.subPeakWidth) / 512
			);
		}
	}

	ShapePath {
		strokeWidth: 0
		strokeColor: root.color
		fillColor: root.color

		startX: 0
		startY: root.baseY

		// First half of hill. Its foot leaves baseY flat: the first control point is on that line.
		PathCubic {
			x: root.width * 0.5
			y: d.ny(192)

			control1X: d.computeX(d.leftControl1X, -1)
			control1Y: root.baseY

			control2X: d.computeX(d.leftControl2X, +1)
			control2Y: d.ny(192)
		}

		// Second half of hill, back down flat onto baseY
		PathCubic {
			x: root.width
			y: root.baseY

			control1X: d.computeX(d.rightControl1X, -1)
			control1Y: d.ny(192)

			control2X: d.computeX(d.rightControl2X, +1)
			control2Y: root.baseY
		}

		// Closing the shape
		PathLine { x: root.width; y: d.ny(384) }
		PathLine { x: 0; y: d.ny(384) }
		PathLine { x: 0; y: root.baseY }
	}
}
