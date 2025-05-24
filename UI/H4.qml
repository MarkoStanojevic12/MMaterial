import QtQuick

import MMaterial.UI as UI

UI.BaseText {
    lineHeight: 1
    elide: Text.ElideRight

    font {
        weight: Font.Bold
        family: UI.PublicSans.bold
        pixelSize: UI.Size.pixel24
    }
}
