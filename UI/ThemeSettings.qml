import MMaterial.UI as UI
import QtQuick

QtObject {
    // Auto theme switch times (local time, format "HH:mm")
    property string autoDarkAt: "19:00"
    property string autoLightAt: "07:00"

    // Optional icon-pack override for Light icons.
    // Supports both qrc:/... and file:/... (or plain local paths converted to file: by the reader).
    // Empty => use the built-in default (MMaterial.Media assets).
    property string lightIconPackConfig: ""

    property ToolTipSettings tooltip: ToolTipSettings {
        font {
            pixelSize: UI.Size.pixel14
            family: UI.Font.normal
        }
    }

    component ToolTipSettings: QtObject {
        property font font
        property color backgroundColor: UI.Theme.text.primary
        property color borderColor: UI.Theme.other.outline
        property int borderWidth: 1
        property int radius: UI.Size.pixel10
        property color textColor: UI.Theme.background.main
    }
}
