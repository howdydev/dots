import Quickshell
import QtQuick

PopupWindow {
    id: popup

    required property var barWindow

    property var sink: null
    property var source: null

    Theme {
        id: theme
    }

    implicitWidth: 340
    implicitHeight: 194

    visible: false
    grabFocus: true
    color: "transparent"

    anchor.window: barWindow

    function showAt(item) {
        if (visible) {
            visible = false
            return
        }

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
                    point.x + item.width - width
                )
            )
        )

        anchor.rect.y = barWindow.height + 6

        visible = true
    }

    function deviceName(node) {
        if (!node)
            return "Unavailable"

        return node.description
            || node.nickname
            || node.name
            || "Unknown device"
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

            spacing: 12

            Text {
                text: "AUDIO"
                color: theme.muted

                font {
                    family: theme.fontFamily
                    pixelSize: 10
                    weight: Font.DemiBold
                    letterSpacing: 1
                }
            }

            // output
            Column {
                width: parent.width
                spacing: 7

                Row {
                    width: parent.width
                    height: 20
                    spacing: 7

                    Text {
                        text: sink?.audio?.muted
                            ? "󰝟"
                            : "󰕾"

                        color: sink?.audio?.muted
                            ? theme.muted
                            : theme.blue

                        font {
                            family: theme.fontFamily
                            pixelSize: 15
                        }
                    }

                    Text {
                        width: 230

                        text: popup.deviceName(sink)

                        color: theme.text
                        elide: Text.ElideRight

                        font {
                            family: theme.fontFamily
                            pixelSize: 11
                            weight: Font.Medium
                        }
                    }

                    Text {
                        width: 40

                        horizontalAlignment: Text.AlignRight

                        text: sink?.audio
                            ? Math.round(
                                sink.audio.volume * 100
                            ) + "%"
                            : "--"

                        color: theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 10
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: 18

                    Rectangle {
                        id: outputTrack

                        anchors.verticalCenter: parent.verticalCenter

                        width: parent.width - 34
                        height: 4

                        radius: 2

                        color: theme.border

                        Rectangle {
                            width: parent.width
                                * Math.min(
                                    1,
                                    sink?.audio?.volume ?? 0
                                )

                            height: parent.height

                            radius: parent.radius
                            color: theme.blue
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.topMargin: -7
                            anchors.bottomMargin: -7

                            cursorShape: Qt.PointingHandCursor

                            function setVolume(x) {
                                if (!sink?.audio)
                                    return

                                sink.audio.volume = Math.max(
                                    0,
                                    Math.min(
                                        1,
                                        x / outputTrack.width
                                    )
                                )
                            }

                            onPressed: mouse => {
                                setVolume(mouse.x)
                            }

                            onPositionChanged: mouse => {
                                if (pressed)
                                    setVolume(mouse.x)
                            }
                        }
                    }

                    Text {
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        text: sink?.audio?.muted
                            ? "󰝟"
                            : "󰕾"

                        color: outputMuteMouse.containsMouse
                            ? theme.cyan
                            : theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 14
                        }

                        MouseArea {
                            id: outputMuteMouse

                            anchors.fill: parent
                            anchors.margins: -6

                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (sink?.audio)
                                    sink.audio.muted =
                                        !sink.audio.muted
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: theme.border
            }

            Column {
                width: parent.width
                spacing: 7

                Row {
                    width: parent.width
                    height: 20
                    spacing: 7

                    Text {
                        text: source?.audio?.muted
                            ? "󰍭"
                            : "󰍬"

                        color: source?.audio?.muted
                            ? theme.muted
                            : theme.violet

                        font {
                            family: theme.fontFamily
                            pixelSize: 15
                        }
                    }

                    Text {
                        width: 230

                        text: popup.deviceName(source)

                        color: theme.text
                        elide: Text.ElideRight

                        font {
                            family: theme.fontFamily
                            pixelSize: 11
                            weight: Font.Medium
                        }
                    }

                    Text {
                        width: 40

                        horizontalAlignment: Text.AlignRight

                        text: source?.audio
                            ? Math.round(
                                source.audio.volume * 100
                            ) + "%"
                            : "--"

                        color: theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 10
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: 18

                    Rectangle {
                        id: microphoneTrack

                        anchors.verticalCenter: parent.verticalCenter

                        width: parent.width - 34
                        height: 4

                        radius: 2

                        color: theme.border

                        Rectangle {
                            width: parent.width
                                * Math.min(
                                    1,
                                    source?.audio?.volume ?? 0
                                )

                            height: parent.height

                            radius: parent.radius
                            color: theme.violet
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.topMargin: -7
                            anchors.bottomMargin: -7

                            cursorShape: Qt.PointingHandCursor

                            function setVolume(x) {
                                if (!source?.audio)
                                    return

                                source.audio.volume = Math.max(
                                    0,
                                    Math.min(
                                        1,
                                        x / microphoneTrack.width
                                    )
                                )
                            }

                            onPressed: mouse => {
                                setVolume(mouse.x)
                            }

                            onPositionChanged: mouse => {
                                if (pressed)
                                    setVolume(mouse.x)
                            }
                        }
                    }

                    Text {
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        text: source?.audio?.muted
                            ? "󰍭"
                            : "󰍬"

                        color: microphoneMuteMouse.containsMouse
                            ? theme.cyan
                            : theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 14
                        }

                        MouseArea {
                            id: microphoneMuteMouse

                            anchors.fill: parent
                            anchors.margins: -6

                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (source?.audio)
                                    source.audio.muted =
                                        !source.audio.muted
                            }
                        }
                    }
                }
            }
        }
    }
}
