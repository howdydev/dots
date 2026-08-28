import Quickshell
import QtQuick

PopupWindow {
    id: popup

    required property var barWindow

    property var player: null

    Theme {
        id: theme
    }

    implicitWidth: 410
    implicitHeight: 154

    visible: false
    grabFocus: true
    color: "transparent"

    anchor.window: barWindow

    function showAt(item) {
        if (!player)
            return

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
                    point.x + item.width / 2 - width / 2
                )
            )
        )

        anchor.rect.y = barWindow.height + 6

        visible = true
    }

    Rectangle {
        anchors.fill: parent

        color: theme.surface
        border.width: 1
        border.color: theme.border

        radius: 3

        Row {
            anchors {
                fill: parent
                margins: 12
            }

            spacing: 14

            // Album art
            Rectangle {
                width: 128
                height: 128

                radius: 3
                color: theme.elevated

                clip: true

                Image {
                    anchors.fill: parent

                    visible:
                        popup.player?.trackArtUrl !== ""

                    source:
                        popup.player?.trackArtUrl || ""

                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }

                Text {
                    anchors.centerIn: parent

                    visible:
                        !popup.player?.trackArtUrl

                    text: "󰝚"
                    color: theme.muted

                    font {
                        family: theme.fontFamily
                        pixelSize: 34
                    }
                }
            }

            Column {
                width: parent.width - 142
                height: parent.height

                spacing: 5

                Text {
                    width: parent.width

                    text:
                        popup.player?.trackTitle
                        || popup.player?.identity
                        || "Nothing playing"

                    color: theme.text

                    elide: Text.ElideRight

                    font {
                        family: theme.fontFamily
                        pixelSize: 13
                        weight: Font.DemiBold
                    }
                }

                Text {
                    width: parent.width

                    text:
                        popup.player?.trackArtist
                        || "Unknown artist"

                    color: theme.muted

                    elide: Text.ElideRight

                    font {
                        family: theme.fontFamily
                        pixelSize: 11
                    }
                }

                Text {
                    width: parent.width

                    text:
                        popup.player?.trackAlbum
                        || ""

                    color: theme.muted

                    elide: Text.ElideRight

                    font {
                        family: theme.fontFamily
                        pixelSize: 10
                    }
                }

                Item {
                    width: 1
                    height: 10
                }

                Row {
                    spacing: 18

                    Text {
                        text: "󰒮"

                        color:
                            previousMouse.containsMouse
                            ? theme.cyan
                            : theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 20
                        }

                        MouseArea {
                            id: previousMouse

                            anchors.fill: parent
                            anchors.margins: -6

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            enabled:
                                popup.player?.canGoPrevious
                                ?? false

                            onClicked:
                                popup.player.previous()
                        }
                    }

                    Text {
                        text:
                            popup.player?.isPlaying
                            ? "󰏤"
                            : "󰐊"

                        color:
                            playMouse.containsMouse
                            ? theme.cyan
                            : theme.blue

                        font {
                            family: theme.fontFamily
                            pixelSize: 21
                        }

                        MouseArea {
                            id: playMouse

                            anchors.fill: parent
                            anchors.margins: -6

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            enabled:
                                popup.player?.canTogglePlaying
                                ?? false

                            onClicked:
                                popup.player.togglePlaying()
                        }
                    }

                    Text {
                        text: "󰒭"

                        color:
                            nextMouse.containsMouse
                            ? theme.cyan
                            : theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 20
                        }

                        MouseArea {
                            id: nextMouse

                            anchors.fill: parent
                            anchors.margins: -6

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            enabled:
                                popup.player?.canGoNext
                                ?? false

                            onClicked:
                                popup.player.next()
                        }
                    }

                    Text {
                        visible:
                            popup.player?.canRaise
                            ?? false

                        text: "󰋜"

                        color:
                            raiseMouse.containsMouse
                            ? theme.cyan
                            : theme.muted

                        font {
                            family: theme.fontFamily
                            pixelSize: 18
                        }

                        MouseArea {
                            id: raiseMouse

                            anchors.fill: parent
                            anchors.margins: -6

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            onClicked:
                                popup.player.raise()
                        }
                    }
                }
            }
        }
    }
}
