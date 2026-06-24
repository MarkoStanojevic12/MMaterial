import QtQuick

import MMaterial.UI as UI

// Holds an IndeterminateClock reservation while `active` is true and always
// releases on destruction, so the shared clock's ref-count can't leak when a
// delegate is recycled mid-animation.
QtObject {
    id: root

    property bool active: false

    property bool _held: false

    onActiveChanged: root._sync()
    Component.onCompleted: root._sync()
    Component.onDestruction: { if (root._held) UI.IndeterminateClock.release(); }

    function _sync() : void {
        if (root.active === root._held)
            return;
        if (root.active)
            UI.IndeterminateClock.acquire();
        else
            UI.IndeterminateClock.release();
        root._held = root.active;
    }
}
