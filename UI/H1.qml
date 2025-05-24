import QtQuick

import MMaterial.UI as UI

UI.BaseText {
    elide: Text.ElideRight
    lineHeight: 1

    font {
        weight: Font.ExtraBold
        family: UI.PublicSans.extraBold
        pixelSize: UI.Size.pixel64
    }
}
