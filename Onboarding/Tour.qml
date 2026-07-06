pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls.Material

import MMaterial.UI as UI
import MMaterial.Controls as Controls
import MMaterial.Media as Media

Item {
    id: root

    default property list<TourStep> steps

    readonly property int count: root.steps.length
    readonly property int currentIndex: d.currentIndex
    readonly property bool running: d.currentIndex >= 0
    readonly property TourStep currentStep: root.running && d.currentIndex < root.count ? root.steps[d.currentIndex] : null

    readonly property int enabledCount: {
        let c = 0;
        for (let i = 0; i < root.count; i++) {
            if (root.steps[i].enabled)
                c++;
        }
        return c;
    }
    readonly property int currentOrdinal: {
        if (!root.running)
            return 0;
        let o = 0;
        for (let i = 0; i <= d.currentIndex && i < root.count; i++) {
            if (root.steps[i].enabled)
                o++;
        }
        return o;
    }

    property color dimColor: UI.Theme.common.black
    property real dimOpacity: 0.65
    property real stagePadding: UI.Size.pixel8
    property real stageRadius: UI.Size.pixel8
    property real popoverWidth: UI.Size.scale * 320
    property bool dismissOnOverlayClick: false
    property bool keyboardNavigation: true

    property string nextText: qsTr("Next")
    property string backText: qsTr("Back")
    property string doneText: qsTr("Done")

    signal started()
    signal finished()
    signal skipped(int stepIndex)
    signal aborted()

    function start(index = 0) {
        const first = d.nextEnabled(index - 1);
        if (first < 0)
            return;

        const wasRunning = root.running;
        d.currentIndex = first;

        if (!wasRunning)
            root.started();
    }

    function next() {
        if (!root.running)
            return;

        const n = d.nextEnabled(d.currentIndex);
        if (n >= 0) {
            d.currentIndex = n;
        } else {
            d.currentIndex = -1;
            root.finished();
        }
    }

    function previous() {
        if (!root.running)
            return;

        const p = d.previousEnabled(d.currentIndex);
        if (p >= 0)
            d.currentIndex = p;
    }

    function stop() {
        if (!root.running)
            return;

        const stepIndex = d.currentIndex;
        d.currentIndex = -1;
        root.skipped(stepIndex);
    }

    function abort() {
        if (!root.running)
            return;

        d.currentIndex = -1;
        root.aborted();
    }

    visible: false

    onCurrentStepChanged: {
        if (root.currentStep)
            root.currentStep.entered();
    }

    component DimArea: MouseArea {
        property bool dismissArea: true

        hoverEnabled: true

        onClicked: {
            if (dismissArea && root.dismissOnOverlayClick)
                root.stop();
        }
        onWheel: (wheel) => { wheel.accepted = true; }
    }

    QtObject {
        id: d

        property int currentIndex: -1

        function nextEnabled(from) {
            for (let i = from + 1; i < root.count; i++) {
                if (root.steps[i].enabled)
                    return i;
            }
            return -1;
        }

        function previousEnabled(from) {
            for (let i = from - 1; i >= 0; i--) {
                if (root.steps[i].enabled)
                    return i;
            }
            return -1;
        }
    }

    Loader {
        id: overlayLoader

        active: root.running
        sourceComponent: overlayComponent
    }

    Component {
        id: overlayComponent

        Item {
            id: overlay

            property bool shown: false

            readonly property Item target: root.currentStep?.target ?? null
            readonly property bool centeredStep: root.currentStep?.centered ?? false
            readonly property bool targetInteractive: root.currentStep?.allowInteraction ?? false
            readonly property real stagePadding: root.currentStep && root.currentStep.padding >= 0 ? root.currentStep.padding : root.stagePadding
            readonly property real stageRadius: root.currentStep && root.currentStep.radius >= 0 ? root.currentStep.radius : root.stageRadius

            // A missing/invisible target can be transient — the overlay still
            // constructing, or a step whose target appears through an animation
            // (a drawer sliding in flips visible only on its first animation
            // tick). Aborting is therefore deferred behind a grace timer that
            // any successful re-measure cancels.
            function updateStage() {
                if (overlay.centeredStep) {
                    targetLossTimer.stop();
                    stage.x = overlay.width / 2;
                    stage.y = overlay.height / 2;
                    stage.width = 0;
                    stage.height = 0;
                    return;
                }

                if (!overlay.target || !overlay.target.visible) {
                    if (!targetLossTimer.running)
                        targetLossTimer.start();
                    return;
                }

                targetLossTimer.stop();

                const r = overlay.target.mapToItem(overlay, 0, 0, overlay.target.width, overlay.target.height);
                let x1 = r.x, y1 = r.y, x2 = r.x + r.width, y2 = r.y + r.height;

                const extra = root.currentStep ? root.currentStep.unionTarget : null;
                if (extra && extra.visible) {
                    const e = extra.mapToItem(overlay, 0, 0, extra.width, extra.height);
                    x1 = Math.min(x1, e.x);
                    y1 = Math.min(y1, e.y);
                    x2 = Math.max(x2, e.x + e.width);
                    y2 = Math.max(y2, e.y + e.height);
                }

                stage.x = x1 - overlay.stagePadding;
                stage.y = y1 - overlay.stagePadding;
                stage.width = (x2 - x1) + overlay.stagePadding * 2;
                stage.height = (y2 - y1) + overlay.stagePadding * 2;
            }

            // Nearest-policy scroll: only moves the closest Flickable ancestor,
            // and only far enough to fully reveal the target. Deferred so the
            // step's entered() handlers reshape the layout first.
            function scrollTargetIntoView() {
                const step = root.currentStep;
                if (!step || !step.autoScroll || !step.target)
                    return;

                let flick = step.target.parent;
                while (flick && !(flick instanceof Flickable))
                    flick = flick.parent;
                if (!flick)
                    return;

                const margin = UI.Size.pixel16;
                const r = step.target.mapToItem(flick.contentItem, 0, 0, step.target.width, step.target.height);

                let toY = flick.contentY;
                if (r.height >= flick.height - margin * 2 || r.y - margin < toY)
                    toY = r.y - margin;
                else if (r.y + r.height + margin > toY + flick.height)
                    toY = r.y + r.height + margin - flick.height;
                toY = Math.max(flick.originY, Math.min(toY, flick.originY + flick.contentHeight - flick.height));

                let toX = flick.contentX;
                if (r.width >= flick.width - margin * 2 || r.x - margin < toX)
                    toX = r.x - margin;
                else if (r.x + r.width + margin > toX + flick.width)
                    toX = r.x + r.width + margin - flick.width;
                toX = Math.max(flick.originX, Math.min(toX, flick.originX + flick.contentWidth - flick.width));

                if (Math.abs(toY - flick.contentY) > 0.5) {
                    scrollYAnimation.target = flick;
                    scrollYAnimation.to = toY;
                    scrollYAnimation.restart();
                }
                if (Math.abs(toX - flick.contentX) > 0.5) {
                    scrollXAnimation.target = flick;
                    scrollXAnimation.to = toX;
                    scrollXAnimation.restart();
                }
            }

            parent: root.Window.window ? root.Overlay.overlay : null
            anchors.fill: parent
            z: 100000
            opacity: overlay.shown ? 1 : 0

            onTargetChanged: overlay.updateStage()
            onWidthChanged: overlay.updateStage()
            onHeightChanged: overlay.updateStage()

            Component.onCompleted: {
                overlay.updateStage();
                Qt.callLater(overlay.scrollTargetIntoView);
            }

            UI.EasedAnimation {
                id: scrollYAnimation

                property: "contentY"
            }

            UI.EasedAnimation {
                id: scrollXAnimation

                property: "contentX"
            }

            Connections {
                target: root

                function onCurrentStepChanged() {
                    Qt.callLater(overlay.scrollTargetIntoView);
                }
            }

            Behavior on opacity { UI.EasedAnimation {} }

            Timer {
                id: targetLossTimer

                interval: 500

                onTriggered: {
                    if (!overlay.target || !overlay.target.visible)
                        root.abort();
                }
            }

            Connections {
                target: overlay.target

                function onXChanged() { overlay.updateStage() }
                function onYChanged() { overlay.updateStage() }
                function onWidthChanged() { overlay.updateStage() }
                function onHeightChanged() { overlay.updateStage() }
                function onVisibleChanged() { overlay.updateStage() }
            }

            // afterAnimating fires post-polish on every rendered frame: the first tick
            // measures the settled layout before the fade-in starts, later ticks track
            // ancestor movement that the target's own geometry signals can't see.
            Connections {
                target: root.Window.window

                function onAfterAnimating() {
                    overlay.updateStage();
                    if (!overlay.shown)
                        overlay.shown = true;
                }
            }

            Shortcut {
                enabled: root.keyboardNavigation && root.running
                sequence: "Escape"
                onActivated: root.stop()
            }

            Shortcut {
                enabled: root.keyboardNavigation && root.running && !overlay.targetInteractive
                sequences: ["Right", "Return", "Enter"]
                onActivated: root.next()
            }

            Shortcut {
                enabled: root.keyboardNavigation && root.running && !overlay.targetInteractive
                sequence: "Left"
                onActivated: root.previous()
            }

            Item {
                id: stage

                // Lower bound keeps the PathArcs' radius strictly positive so a
                // collapsed stage (centered steps) never degenerates them.
                readonly property real cornerRadius: Math.max(0.01, Math.min(overlay.stageRadius, stage.width / 2, stage.height / 2))

                Behavior on x { enabled: overlay.shown; UI.EasedAnimation {} }
                Behavior on y { enabled: overlay.shown; UI.EasedAnimation {} }
                Behavior on width { enabled: overlay.shown; UI.EasedAnimation {} }
                Behavior on height { enabled: overlay.shown; UI.EasedAnimation {} }
            }

            Shape {
                anchors.fill: parent

                ShapePath {
                    strokeColor: "transparent"
                    fillColor: Qt.rgba(root.dimColor.r, root.dimColor.g, root.dimColor.b, root.dimOpacity)
                    fillRule: ShapePath.OddEvenFill

                    startX: 0
                    startY: 0

                    PathLine { x: overlay.width; y: 0 }
                    PathLine { x: overlay.width; y: overlay.height }
                    PathLine { x: 0; y: overlay.height }
                    PathLine { x: 0; y: 0 }

                    PathMove { x: stage.x + stage.cornerRadius; y: stage.y }
                    PathLine { x: stage.x + stage.width - stage.cornerRadius; y: stage.y }
                    PathArc {
                        x: stage.x + stage.width
                        y: stage.y + stage.cornerRadius
                        radiusX: stage.cornerRadius
                        radiusY: stage.cornerRadius
                    }
                    PathLine { x: stage.x + stage.width; y: stage.y + stage.height - stage.cornerRadius }
                    PathArc {
                        x: stage.x + stage.width - stage.cornerRadius
                        y: stage.y + stage.height
                        radiusX: stage.cornerRadius
                        radiusY: stage.cornerRadius
                    }
                    PathLine { x: stage.x + stage.cornerRadius; y: stage.y + stage.height }
                    PathArc {
                        x: stage.x
                        y: stage.y + stage.height - stage.cornerRadius
                        radiusX: stage.cornerRadius
                        radiusY: stage.cornerRadius
                    }
                    PathLine { x: stage.x; y: stage.y + stage.cornerRadius }
                    PathArc {
                        x: stage.x + stage.cornerRadius
                        y: stage.y
                        radiusX: stage.cornerRadius
                        radiusY: stage.cornerRadius
                    }
                }
            }

            DimArea {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: Math.max(0, stage.y)
            }

            DimArea {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: Math.max(0, overlay.height - stage.y - stage.height)
            }

            DimArea {
                y: stage.y
                anchors.left: parent.left
                width: Math.max(0, stage.x)
                height: stage.height
            }

            DimArea {
                y: stage.y
                anchors.right: parent.right
                width: Math.max(0, overlay.width - stage.x - stage.width)
                height: stage.height
            }

            DimArea {
                x: stage.x
                y: stage.y
                width: stage.width
                height: stage.height
                dismissArea: false
                visible: !overlay.targetInteractive
            }

            // Sonar ping around the cutout while the step can only advance
            // through the user's own action (interaction allowed, Next hidden).
            Rectangle {
                id: attentionPulse

                readonly property bool active: overlay.targetInteractive
                                               && !(root.currentStep?.nextButtonVisible ?? true)
                                               && !overlay.centeredStep
                readonly property real maxSpread: UI.Size.pixel16
                property real spread: 0

                visible: attentionPulse.active
                color: "transparent"
                radius: stage.cornerRadius + attentionPulse.spread
                opacity: (1 - attentionPulse.spread / attentionPulse.maxSpread) * 0.9

                border {
                    width: UI.Size.pixel2
                    color: UI.Theme.primary.main
                }

                x: stage.x - attentionPulse.spread
                y: stage.y - attentionPulse.spread
                width: stage.width + attentionPulse.spread * 2
                height: stage.height + attentionPulse.spread * 2

                SequentialAnimation {
                    running: attentionPulse.active
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: attentionPulse
                        property: "spread"
                        from: 0
                        to: attentionPulse.maxSpread
                        duration: 1100
                        easing.type: Easing.OutCubic
                    }

                    PauseAnimation { duration: 350 }
                }
            }

            Rectangle {
                id: popover

                readonly property real gap: UI.Size.pixel12
                readonly property real edgeMargin: UI.Size.pixel16
                readonly property int placement: {
                    const hint = root.currentStep ? root.currentStep.side : TourStep.Side.Auto;
                    if (hint !== TourStep.Side.Auto)
                        return hint;
                    if (stage.y + stage.height + popover.gap + popover.height + popover.edgeMargin <= overlay.height)
                        return TourStep.Side.Bottom;
                    if (stage.y - popover.gap - popover.height - popover.edgeMargin >= 0)
                        return TourStep.Side.Top;
                    if (stage.x + stage.width + popover.gap + popover.width + popover.edgeMargin <= overlay.width)
                        return TourStep.Side.Right;
                    if (stage.x - popover.gap - popover.width - popover.edgeMargin >= 0)
                        return TourStep.Side.Left;
                    return TourStep.Side.Bottom;
                }

                function clamp(value, min, max) {
                    return Math.max(min, Math.min(max, value));
                }

                x: {
                    const maxX = Math.max(popover.edgeMargin, overlay.width - popover.width - popover.edgeMargin);
                    if (overlay.centeredStep)
                        return (overlay.width - popover.width) / 2;
                    switch (popover.placement) {
                    case TourStep.Side.Left:
                        return popover.clamp(stage.x - popover.gap - popover.width, popover.edgeMargin, maxX);
                    case TourStep.Side.Right:
                        return popover.clamp(stage.x + stage.width + popover.gap, popover.edgeMargin, maxX);
                    default:
                        return popover.clamp(stage.x + stage.width / 2 - popover.width / 2, popover.edgeMargin, maxX);
                    }
                }
                y: {
                    const maxY = Math.max(popover.edgeMargin, overlay.height - popover.height - popover.edgeMargin);
                    if (overlay.centeredStep)
                        return (overlay.height - popover.height) / 2;
                    switch (popover.placement) {
                    case TourStep.Side.Top:
                        return popover.clamp(stage.y - popover.gap - popover.height, popover.edgeMargin, maxY);
                    case TourStep.Side.Bottom:
                        return popover.clamp(stage.y + stage.height + popover.gap, popover.edgeMargin, maxY);
                    default:
                        return popover.clamp(stage.y + stage.height / 2 - popover.height / 2, popover.edgeMargin, maxY);
                    }
                }

                width: Math.min(root.popoverWidth, overlay.width - popover.edgeMargin * 2)
                height: contentColumn.implicitHeight + UI.Size.pixel20 * 2
                radius: UI.Size.pixel12
                color: UI.Theme.background.paper

                Rectangle {
                    id: arrow

                    visible: !overlay.centeredStep
                    width: UI.Size.pixel12
                    height: width
                    rotation: 45
                    color: popover.color
                    z: -1

                    x: {
                        switch (popover.placement) {
                        case TourStep.Side.Left:
                            return popover.width - arrow.width / 2;
                        case TourStep.Side.Right:
                            return -arrow.width / 2;
                        default:
                            return popover.clamp(stage.x + stage.width / 2 - popover.x - arrow.width / 2,
                                                 popover.radius,
                                                 popover.width - popover.radius - arrow.width);
                        }
                    }
                    y: {
                        switch (popover.placement) {
                        case TourStep.Side.Top:
                            return popover.height - arrow.height / 2;
                        case TourStep.Side.Bottom:
                            return -arrow.height / 2;
                        default:
                            return popover.clamp(stage.y + stage.height / 2 - popover.y - arrow.height / 2,
                                                 popover.radius,
                                                 popover.height - popover.radius - arrow.height);
                        }
                    }
                }

                ColumnLayout {
                    id: contentColumn

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: UI.Size.pixel20
                    }
                    spacing: UI.Size.pixel8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: UI.Size.pixel8

                        UI.H6 {
                            Layout.fillWidth: true
                            text: root.currentStep?.title ?? ""
                            visible: text !== ""
                            wrapMode: Text.Wrap
                        }

                        Media.Icon {
                            Layout.alignment: Qt.AlignTop
                            iconData: Media.Icons.heavy.close
                            size: UI.Size.pixel16
                            color: UI.Theme.text.secondary
                            interactive: true

                            onClicked: root.stop()
                        }
                    }

                    UI.B2 {
                        Layout.fillWidth: true
                        text: root.currentStep?.description ?? ""
                        visible: text !== ""
                        color: UI.Theme.text.secondary
                        wrapMode: Text.Wrap
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: UI.Size.pixel8
                        spacing: UI.Size.pixel8

                        UI.Caption {
                            visible: root.enabledCount > 1
                            text: root.currentOrdinal + " / " + root.enabledCount
                            color: UI.Theme.text.disabled
                        }

                        Item { Layout.fillWidth: true }

                        Controls.MButton {
                            visible: (root.currentStep?.skipButtonText ?? "") !== ""
                            type: Controls.MButton.Type.Text
                            accent: UI.Theme.passive
                            size: UI.Size.Grade.S
                            text: root.currentStep?.skipButtonText ?? ""

                            onClicked: root.currentStep.skipClicked()
                        }

                        Controls.MButton {
                            visible: (root.currentStep?.backButtonVisible ?? true) && d.previousEnabled(root.currentIndex) >= 0
                            type: Controls.MButton.Type.Outlined
                            size: UI.Size.Grade.S
                            text: root.backText

                            onClicked: root.previous()
                        }

                        Controls.MButton {
                            visible: root.currentStep?.nextButtonVisible ?? true
                            type: Controls.MButton.Type.Contained
                            size: UI.Size.Grade.S
                            text: d.nextEnabled(root.currentIndex) < 0 ? root.doneText : root.nextText

                            onClicked: root.next()
                        }
                    }
                }
            }
        }
    }
}
