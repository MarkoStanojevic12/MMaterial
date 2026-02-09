pragma Singleton

import QtQuick
import MMaterial.UI as UI

UI.ThemeBase {
    id: root
    objectName: "Auto UI.Theme"

    property UI.ThemeBase darkTheme: UI.DarkTheme
    property UI.ThemeBase lightTheme: UI.LightTheme
    readonly property UI.ThemeBase activeTheme: d.activeTheme

    QtObject {
        id: d

        property UI.ThemeBase activeTheme: UI.DarkTheme

        function parseHHmmToMinutes(hhmm) : int {
            if (!hhmm || hhmm.length < 4)
                return -1;

            const parts = hhmm.split(":");
            if (parts.length !== 2)
                return -1;

            const h = parseInt(parts[0], 10);
            const m = parseInt(parts[1], 10);
            if (isNaN(h) || isNaN(m))
                return -1;
            if (h < 0 || h > 23 || m < 0 || m > 59)
                return -1;

            return h * 60 + m;
        }

        function minutesNow() : int {
            const d = new Date();
            return d.getHours() * 60 + d.getMinutes();
        }

        function isDarkNow() : bool {
            const darkAt = d.parseHHmmToMinutes(UI.Theme.settings.autoDarkAt);
            const lightAt = d.parseHHmmToMinutes(UI.Theme.settings.autoLightAt);
            const now = d.minutesNow();

            if (darkAt < 0 || lightAt < 0)
                return false;

            if (darkAt === lightAt)
                return false;

            if (darkAt < lightAt) {
                return now >= darkAt && now < lightAt;
            }

            return now >= darkAt || now < lightAt;
        }

        function updateActiveTheme() : void {
            const wantDark = d.isDarkNow();
            const newTheme = wantDark ? root.darkTheme : root.lightTheme;
            if (d.activeTheme !== newTheme)
                d.activeTheme = newTheme;
        }
    }



    // Component.onCompleted: d.updateActiveTheme()

    Timer {
        interval: 60000 // 60 seconds
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: d.updateActiveTheme()
    }

    primary: d.activeTheme?.primary ?? null
    secondary: d.activeTheme?.secondary ?? null
    info: d.activeTheme?.info ?? null
    success: d.activeTheme?.success ?? null
    warning: d.activeTheme?.warning ?? null
    error: d.activeTheme?.error ?? null
    text: d.activeTheme?.text ?? null
    background: d.activeTheme?.background ?? null
    action: d.activeTheme?.action ?? null
    other: d.activeTheme?.other ?? null
    main: d.activeTheme?.main ?? null
    social: d.activeTheme?.social ?? null

    common: d.activeTheme?.common ?? common
    defaultNeutral: d.activeTheme?.defaultNeutral ?? defaultNeutral
    passive: d.activeTheme?.passive ?? passive
}
