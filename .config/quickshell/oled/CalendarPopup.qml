import Quickshell
import QtQuick

PopupWindow {
    id: popup

    required property var barWindow

    Theme {
        id: theme
    }

    property date viewedMonth: new Date()

    implicitWidth: 306
    implicitHeight: 300

    visible: false
    grabFocus: true
    color: "transparent"

    anchor.window: barWindow

    readonly property int year: viewedMonth.getFullYear()
    readonly property int month: viewedMonth.getMonth()

    readonly property int firstDay:
        (new Date(year, month, 1).getDay() + 6) % 7

    readonly property int daysInMonth:
        new Date(year, month + 1, 0).getDate()

    function showAt(item) {
        if (visible) {
            visible = false
            return
        }

        viewedMonth = new Date(
            new Date().getFullYear(),
            new Date().getMonth(),
            1
        )

        const point = item.mapToItem(
            barWindow.contentItem,
            0,
            item.height
        )

        anchor.rect.x = Math.round(
            Math.max(
                8,
                Math.min(
                    barWindow.width - width - 8,
                    point.x + item.width / 2 - width / 2
                )
            )
        )

        anchor.rect.y = barWindow.height + 6

        visible = true
    }

    function previousMonth() {
        viewedMonth = new Date(year, month - 1, 1)
    }

    function nextMonth() {
        viewedMonth = new Date(year, month + 1, 1)
    }

    function isToday(day) {
        const now = new Date()

        return day === now.getDate()
            && month === now.getMonth()
            && year === now.getFullYear()
    }

    Rectangle {
        anchors.fill: parent

        color: theme.surface
        border.width: 1
        border.color: theme.border
        radius: 3

        Column {
            anchors {
                fill: parent
                margins: 12
            }

            spacing: 10

            // Month header
            Item {
                width: parent.width
                height: 30

                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }

                    text: "󰁍"
                    color: previousMouse.containsMouse
                        ? theme.cyan
                        : theme.muted

                    font {
                        family: theme.fontFamily
                        pixelSize: 16
                    }

                    MouseArea {
                        id: previousMouse

                        anchors.fill: parent
                        anchors.margins: -6

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: popup.previousMonth()
                    }
                }

                Text {
                    anchors.centerIn: parent

                    text: Qt.formatDate(
                        popup.viewedMonth,
                        "MMMM yyyy"
                    )

                    color: theme.text

                    font {
                        family: theme.fontFamily
                        pixelSize: 13
                        weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            const now = new Date()

                            popup.viewedMonth = new Date(
                                now.getFullYear(),
                                now.getMonth(),
                                1
                            )
                        }
                    }
                }

                Text {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    text: "󰁔"
                    color: nextMouse.containsMouse
                        ? theme.cyan
                        : theme.muted

                    font {
                        family: theme.fontFamily
                        pixelSize: 16
                    }

                    MouseArea {
                        id: nextMouse

                        anchors.fill: parent
                        anchors.margins: -6

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: popup.nextMonth()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: theme.border
            }

            // Weekday headings
            Grid {
                width: parent.width

                columns: 7
                rowSpacing: 0
                columnSpacing: 0

                Repeater {
                    model: [
                        "M",
                        "T",
                        "W",
                        "T",
                        "F",
                        "S",
                        "S"
                    ]

                    Item {
                        required property var modelData

                        width: 40
                        height: 22

                        Text {
                            anchors.centerIn: parent

                            text: modelData
                            color: theme.muted

                            font {
                                family: theme.fontFamily
                                pixelSize: 10
                                weight: Font.DemiBold
                            }
                        }
                    }
                }
            }

            // Days
            Grid {
                width: parent.width

                columns: 7
                rowSpacing: 3
                columnSpacing: 0

                Repeater {
                    model: 42

                    Item {
                        required property int index

                        readonly property int day:
                            index - popup.firstDay + 1

                        readonly property bool valid:
                            day > 0
                            && day <= popup.daysInMonth

                        readonly property bool today:
                            valid && popup.isToday(day)

                        width: 40
                        height: 28

                        Text {
                            anchors.centerIn: parent

                            visible: parent.valid

                            text: parent.day

                            color: parent.today
                                ? theme.blue
                                : theme.text

                            font {
                                family: theme.fontFamily
                                pixelSize: 11

                                weight: parent.today
                                    ? Font.DemiBold
                                    : Font.Medium
                            }
                        }

                        Rectangle {
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                bottom: parent.bottom
                            }

                            visible: parent.today

                            width: 14
                            height: 2

                            color: theme.blue
                        }
                    }
                }
            }
        }
    }
}
