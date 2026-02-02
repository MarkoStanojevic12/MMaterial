import QtQuick

import MMaterial.UI as UI

QtObject{
    id: _root

    required property color main
    required property color contrastText
    property bool isDarkMode: Theme.currentTheme == DarkTheme

    property color lighter: isDarkMode ? Qt.darker(main, 1.6) : Qt.lighter(main, 1.6)
    property color light: isDarkMode ? Qt.darker(main, 1.3) : Qt.lighter(main, 1.3)
    property color dark: isDarkMode ? Qt.lighter(main, 1.3) : Qt.darker(main, 1.3)
    property color darker: isDarkMode ? Qt.lighter(main, 1.6) : Qt.darker(main, 1.6)

    property UI.PaletteTransparent transparent: UI.PaletteTransparent{
        mainColor: _root.main
    }
}
