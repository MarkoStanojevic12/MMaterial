import QtQuick

import MMaterial.Controls as Controls
import MMaterial.UI as UI

Text {
    id: _root

    property string tooltipText: _root.text
    property bool showTooltip: _root.truncated

    property alias tooltip: tooltip
    property alias hovered: _hoverHandler.hovered

	color: UI.Theme.text.primary
    font.family: UI.Font.normal

    HoverHandler{
        id: _hoverHandler

        enabled: _root.showTooltip
    }

	Controls.MToolTip {
        id: tooltip

        visible: _hoverHandler.hovered && _root.showTooltip
        text: _root.tooltipText
        delay: 300
    }
}
