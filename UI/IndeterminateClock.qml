pragma Singleton

import QtQuick

import MMaterial.UI as UI

// Single shared driver for indeterminate "sweep" animations (the MProgressBar
// indeterminate bar and the DeviceStatusList status shimmer). Every consumer
// binds to `phase` instead of running its own animation, so all delegates stay
// perfectly in phase and the whole app pays for ONE animation job no matter how
// many cards are on screen. The job runs only while at least one consumer holds
// a ticket (acquire/release), so the scene still goes fully idle — no frames
// requested — once nothing is animating.
Item {
    id: root

    // Ping-pongs 0 -> 1 -> 0 with eased legs (800 ms each, matching the original
    // per-delegate animations). Consumers map this onto their own range.
    property real phase: 0

    readonly property bool running: root._activeCount > 0
    property int _activeCount: 0

    function acquire() : void { root._activeCount++; }
    function release() : void { if (root._activeCount > 0) root._activeCount--; }

    SequentialAnimation {
        running: root.running
        loops: Animation.Infinite

        UI.EasedAnimation { target: root; property: "phase"; from: 0; to: 1; duration: 800 }
        UI.EasedAnimation { target: root; property: "phase"; from: 1; to: 0; duration: 800 }
    }
}
