import MMaterial.UI as UI

import QtQuick

QtObject {
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
