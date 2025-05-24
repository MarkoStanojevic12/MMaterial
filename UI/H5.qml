import QtQuick

import MMaterial.UI as UI

UI.BaseText {
    lineHeight: 1.3
    elide: Text.ElideRight

    font {
        weight: Font.Bold
        family: UI.PublicSans.bold
        pixelSize: UI.Size.pixel20
    }
}
