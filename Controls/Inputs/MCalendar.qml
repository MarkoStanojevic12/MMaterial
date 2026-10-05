pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Templates as T

import MMaterial.UI as UI

ColumnLayout {
    id: calendarRoot

    property var beginDate: d.firstSelectedDate ?? null
    property var endDate: d.lastSelectedDate ?? null

    // The month shown; the current one at first
    property alias currentMonth: grid.month
    property alias currentYear: grid.year

    // Month and day names, and the first day of the week (Qt.locale("sr_Latn_RS") starts on Monday)
    property alias locale: grid.locale
    // How the days of the week are named above the grid: Locale.NarrowFormat ("M"), ShortFormat
    // ("Mon") or LongFormat
    property int dayNameFormat: Locale.NarrowFormat
    property string noDateText: qsTr("No date selected")
    // A first tap picks a day and a second one the other end of a range; false: every tap picks
    // one day
    property bool rangeSelection: true

    property var dateFormater: (date) => {
        if (!date)
            return calendarRoot.noDateText;
        var year = date.getFullYear().toString().slice(-2);
        var month = calendarRoot.locale.monthName(date.getMonth(), Locale.ShortFormat);
        var day = String(date.getDate()).padStart(2, '0');
        return `${month} ${day}, '${year}`;
    }

    // The month's name on its own, capitalized ("October", "Oktobar")
    property var monthName: (date) => {
        const name = calendarRoot.locale.standaloneMonthName(date.getMonth(), Locale.LongFormat);
        return name.charAt(0).toLocaleUpperCase() + name.slice(1);
    }

    // Shows the month of `date`
    function showMonth(date) {
        if (!date)
            return;
        grid.year = date.getFullYear();
        grid.month = date.getMonth();
    }

    // Selects the days from `begin` through `end` (one day when `end` is missing) and shows the
    // month of `begin`; without `begin` it clears the selection
    function select(begin, end) {
        dateMA.selectionActive = false;
        if (!begin) {
            d.reset();
            return;
        }
        const first = new Date(begin.getFullYear(), begin.getMonth(), begin.getDate());
        const last = end ? new Date(end.getFullYear(), end.getMonth(), end.getDate()) : first;
        const swap = d.compareDates(last, first) < 0;
        d.firstSelectedDate = swap ? last : first;
        d.lastSelectedDate = swap ? first : last;
        calendarRoot.showMonth(d.firstSelectedDate);
    }

    function clearSelection() {
        calendarRoot.select(null);
    }

    function nextMonth() {
        if (grid.month === 11) {
            grid.year = grid.year + 1;
            grid.month = 0;
        } else {
            grid.month = grid.month + 1;
        }

    }

    function previousMonth() {
        if (grid.month === 0) {
            grid.year = grid.year - 1;
            grid.month = 11;
        } else {
            grid.month = grid.month - 1;
        }
    }


    implicitWidth: 264 * UI.Size.scale

    component DaysRow: T.AbstractDayOfWeekRow {
        id: control

        implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                contentItem.implicitWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                 contentItem.implicitHeight + topPadding + bottomPadding)

        spacing: 6
        topPadding: 6
        bottomPadding: 6
        font.bold: true

        contentItem: RowLayout {
            spacing: control.spacing
            Repeater {
                model: control.source
                delegate: control.delegate
            }
        }
    }

    component MonthGridLayout: T.AbstractMonthGrid {
        id: calControl

        function itemAt(x, y) {
            return gridLayout.childAt(x, y)
        }

        implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                contentItem.implicitWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                 contentItem.implicitHeight + topPadding + bottomPadding)

        spacing: 6

        contentItem: GridLayout {
            id: gridLayout

            rows: 5
            columns: 7
            rowSpacing: calControl.spacing
            columnSpacing: calControl.spacing
            uniformCellHeights: true
            uniformCellWidths: true

            Repeater {
                model: calControl.source
                delegate: calControl.delegate
            }
        }
    }

    DaysRow {
        id: daysOfWeek

        Layout.fillWidth: true
        locale: grid.locale
        spacing: grid.spacing

        delegate: Item {
            id: dayDelegate

            required property string narrowName
            required property string shortName
            required property string longName

            Layout.preferredWidth: UI.Size.pixel36
            Layout.preferredHeight: UI.Size.pixel40

			UI.Caption {
                anchors.fill: dayDelegate

                text: calendarRoot.dayNameFormat === Locale.LongFormat ? dayDelegate.longName
                      : calendarRoot.dayNameFormat === Locale.ShortFormat ? dayDelegate.shortName : dayDelegate.narrowName
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: UI.Theme.text.secondary
            }
        }
    }

    MonthGridLayout {
        id: grid

        function containsMouse(mouseX, mouseY, delX, delY, delHeight, delWidth) {
            return mouseX >= delX && mouseX <= delX + delWidth && mouseY >= delY && mouseY <= delY + delHeight;
        }

        spacing: UI.Size.pixel1 * 2
        month: new Date().getMonth()
        year: new Date().getFullYear()
        locale: Qt.locale("en_US")
        implicitWidth: calendarRoot.width

        Layout.fillWidth: true
		Layout.topMargin: -UI.Size.pixel10

        delegate: Item {
            id: del

            required property var model
            readonly property var year: model.year
            readonly property var month: model.month
            readonly property var day: model.day
            readonly property var date: new Date(year, month, day)
            readonly property bool selected: d.isSelected(model.day, model.month, model.year, d.firstSelectedDate, d.lastSelectedDate)
            readonly property bool highlighted: d.highlightedElement === this
            readonly property bool isFirstSelected: d.firstSelectedDate ? d.firstSelectedDate.getTime() === del.date.getTime() : false
            readonly property bool isLastSelected: d.lastSelectedDate ? d.lastSelectedDate.getTime() === del.date.getTime() : false

            Layout.preferredHeight: UI.Size.pixel36
            Layout.preferredWidth: UI.Size.pixel36

            opacity: del.model.month === grid.month ? (dateMA.pressed && del.highlighted ? 0.8 : 1) : 0.3

            Rectangle {
                id: selectionRect

                property bool useIndividualRadii: d.firstSelectedDate !== d.lastSelectedDate
                readonly property bool firstIsEarlier: !d.firstSelectedDate || !d.lastSelectedDate ? false : d.compareDates(d.firstSelectedDate, d.lastSelectedDate);

                color: del.selected ? UI.Theme.primary.dark : "transparent"

                radius: selectionRect.height / 2
                topLeftRadius: useIndividualRadii ? (del.isFirstSelected && firstIsEarlier ? selectionRect.radius : del.isLastSelected && !firstIsEarlier ? selectionRect.radius : 0) : undefined
                bottomLeftRadius: useIndividualRadii ? (del.isFirstSelected && firstIsEarlier ? selectionRect.radius : del.isLastSelected && !firstIsEarlier ? selectionRect.radius : 0) : undefined
                topRightRadius: useIndividualRadii ? (del.isLastSelected && firstIsEarlier ? selectionRect.radius : del.isFirstSelected && !firstIsEarlier ? selectionRect.radius : 0) : undefined
                bottomRightRadius: useIndividualRadii ? (del.isLastSelected && firstIsEarlier ? selectionRect.radius : del.isFirstSelected && !firstIsEarlier ? selectionRect.radius : 0) : undefined

                anchors {
                    fill: del
					leftMargin: useIndividualRadii ? -UI.Size.pixel1 : 0
					rightMargin: useIndividualRadii ? -UI.Size.pixel1 : 0
                }
            }

            Rectangle {
                id: hoverRect

                anchors.fill: del
                radius: height / 2
                color: "transparent"

                border {
                    width: del.highlighted && !dateMA.pressed ? 1 : 0
                    color: del.selected ? UI.Theme.primary.lighter : UI.Theme.text.secondary
                }
            }

			UI.B2 {
                id: dateLabel

                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: del.model.day
                color: del.selected ? UI.Theme.primary.lighter : UI.Theme.text.primary
            }
        }

		MouseArea {
			id: dateMA

			anchors.fill: grid
			hoverEnabled: true
			cursorShape: Qt.PointingHandCursor
			acceptedButtons: Qt.LeftButton | Qt.RightButton

			property bool selectionActive: false

			onClicked: (mouse) => {
				if (mouse.button == Qt.RightButton) {
					d.reset();
					selectionActive = false;
					return;
				}

				if (!d.highlightedElement) return;

				let date = d.highlightedElement.date;

				if (!selectionActive || !calendarRoot.rangeSelection) {
					// Start new selection
					d.firstSelectedDate = date;
					d.lastSelectedDate = date;
					selectionActive = calendarRoot.rangeSelection;
				} else {
					// Complete the range selection
					if (d.compareDates(date, d.firstSelectedDate) < 0) {
						d.lastSelectedDate = d.firstSelectedDate;
						d.firstSelectedDate = date;
					} else {
						d.lastSelectedDate = date;
					}
					selectionActive = false;
				}
			}
		}
    }

    QtObject {
        id: d

        readonly property var highlightedElement: dateMA.containsMouse ? grid.itemAt(dateMA.mouseX, dateMA.mouseY) : null
        property var selectedDates: []
        property var initPointDate: null
        property var firstSelectedDate: null
        property var lastSelectedDate: null

        function reset() {
            d.firstSelectedDate = null;
            d.lastSelectedDate = null;
            d.initPointDate = null;
        }

        function compareDates(date1, date2) {
            if (!date1 || !date2) return;

            if (date1.getTime() < date2.getTime()) return -1;
            if (date1.getTime() > date2.getTime()) return 1;
            return 0;
        }

        function isSelected(day, month, year, firstDate, lastDate) {
            if (!firstDate || !lastDate) return false;

            let currentDate = new Date(year, month, day);

            let firstDateComparisson = d.compareDates(currentDate, firstDate);
            let lastDateComparisson = d.compareDates(currentDate, lastDate);

            if (firstDateComparisson === 0 || lastDateComparisson === 0) return true;
            if (firstDateComparisson > 0 && lastDateComparisson < 0) return true;

            return false;
        }
    }
}
