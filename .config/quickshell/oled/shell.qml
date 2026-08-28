import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import QtQuick

ShellRoot {
    id: root

    readonly property color background: "#080A0F"
    readonly property color surface: "#0D1018"
    readonly property color surfaceHover: "#151C2C"
    readonly property color border: "#202638"

    readonly property color text: "#A9B1D6"
    readonly property color muted: "#565F89"

    readonly property color blue: "#7AA2F7"
    readonly property color cyan: "#7DCFFF"
    readonly property color violet: "#BB9AF7"
    readonly property color red: "#F7768E"

    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    readonly property var activePlayer: {
        const players = Mpris.players.values

        if (players.length === 0)
            return null

        const playing = players.find(player => player.isPlaying)
        return playing || players[0]
    }

    property int notificationCount: 0
    property string notificationState: "none"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Process {
        id: swayncState

        running: true
        command: ["swaync-client", "-swb"]

        stdout: SplitParser {
            onRead: message => {
                try {
                    const state = JSON.parse(message)

                    root.notificationCount =
                        parseInt(state.text) || 0

                    root.notificationState =
                        state.alt || "none"
                } catch (error) {
                }
            }
        }

        onRunningChanged: {
            if (!running)
                swayncRestart.start()
        }
    }

    Timer {
        id: swayncRestart

        interval: 1000
        repeat: false

        onTriggered: swayncState.running = true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 36
            exclusiveZone: 36
            color: root.background

            readonly property var hyprMonitor:
                Hyprland.monitorFor(screen)

            readonly property var audioSink:
                Pipewire.defaultAudioSink

            readonly property var audioSource:
                Pipewire.defaultAudioSource

            PwObjectTracker {
                objects: [
                    bar.audioSink,
                    bar.audioSource
                ]
            }

            ScriptModel {
                id: monitorWorkspaces

                values: [...Hyprland.workspaces.values]
                    .filter(workspace =>
                        workspace.monitor
                        && bar.hyprMonitor
                        && workspace.monitor.name === bar.hyprMonitor.name
                    )
                    .sort((a, b) => a.id - b.id)
            }

            // workspaces
            Row {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }

                height: 36
                spacing: 3

                Repeater {
                    model: monitorWorkspaces

                    Item {
                        required property var modelData
                        required property int index

                        readonly property var workspace:
                            modelData

                        readonly property bool occupied:
                            workspace.toplevels.values.length > 0

                        width: 30
                        height: 36

                        Text {
                            anchors.centerIn: parent

                            text: String(index + 1)

                            color: {
                                if (workspace.urgent)
                                    return root.red

                                if (workspace.active)
                                    return root.blue

                                if (occupied)
                                    return root.text

                                return root.muted
                            }

                            font {
                                family: root.fontFamily
                                pixelSize: 13

                                weight:
                                    workspace.active
                                    ? Font.DemiBold
                                    : Font.Medium
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 120
                                }
                            }
                        }

                        Rectangle {
                            anchors {
                                horizontalCenter:
                                    parent.horizontalCenter

                                bottom:
                                    parent.bottom
                            }

                            width:
                                workspace.active
                                ? 18
                                : 0

                            height: 2
                            color: root.blue

                            Behavior on width {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            cursorShape:
                                Qt.PointingHandCursor

                            onClicked:
                                workspace.activate()
                        }
                    }
                }
            }

            // clock
            Item {
                id: clockItem

                anchors.centerIn: parent

                width: clockRow.implicitWidth
                height: 36

                Row {
                    id: clockRow

                    anchors.centerIn: parent

                    height: 36
                    spacing: 12

                    Text {
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter

                        text: Qt.formatDateTime(
                            clock.date,
                            "ddd d MMM"
                        )

                        color:
                            clockMouse.containsMouse
                            ? root.text
                            : root.muted

                        font {
                            family: root.fontFamily
                            pixelSize: 13
                            weight: Font.Medium
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }

                    Text {
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter

                        text: Qt.formatDateTime(
                            clock.date,
                            "HH:mm"
                        )

                        color:
                            clockMouse.containsMouse
                            ? root.cyan
                            : root.text

                        font {
                            family: root.fontFamily
                            pixelSize: 13
                            weight: Font.DemiBold
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }

                MouseArea {
                    id: clockMouse

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        audioPopup.visible = false
                        mediaPopup.visible = false
                        powerPopup.visible = false

                        calendarPopup.showAt(clockItem)
                    }
                }
            }

            // right side
            Row {
                anchors {
                    right: parent.right
                    rightMargin: 12
                    verticalCenter: parent.verticalCenter
                }

                height: 36
                spacing: 14

                // media
                Row {
                    id: mediaRow

                    visible:
                        root.activePlayer !== null

                    height: 36
                    spacing: 7

                    Text {
                        height: parent.height

                        verticalAlignment:
                            Text.AlignVCenter

                        text: "󰝚"

                        color:
                            root.activePlayer?.isPlaying
                            ? root.cyan
                            : root.muted

                        font {
                            family: root.fontFamily
                            pixelSize: 16
                        }
                    }

                    Text {
                        id: mediaTitle

                        width: 220
                        height: parent.height

                        verticalAlignment:
                            Text.AlignVCenter

                        text: {
                            if (!root.activePlayer)
                                return ""

                            const title =
                                root.activePlayer.trackTitle
                                || root.activePlayer.identity
                                || "Media"

                            const artist =
                                root.activePlayer.trackArtist
                                || ""

                            return artist
                                ? artist + " — " + title
                                : title
                        }

                        color:
                            mediaTitleMouse.containsMouse
                            ? root.cyan
                            : root.text

                        elide: Text.ElideRight

                        font {
                            family: root.fontFamily
                            pixelSize: 12
                            weight: Font.Medium
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }

                        MouseArea {
                            id: mediaTitleMouse

                            anchors.fill: parent
                            anchors.margins: -4

                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                calendarPopup.visible = false
                                audioPopup.visible = false
                                powerPopup.visible = false

                                mediaPopup.showAt(mediaRow)
                            }
                        }
                    }

                    Text {
                        height: parent.height

                        verticalAlignment:
                            Text.AlignVCenter

                        text: "󰒮"

                        color:
                            previousMouse.containsMouse
                            ? root.blue
                            : root.muted

                        font {
                            family: root.fontFamily
                            pixelSize: 16
                        }

                        MouseArea {
                            id: previousMouse

                            anchors.fill: parent
                            anchors.margins: -4

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            enabled:
                                root.activePlayer?.canGoPrevious
                                ?? false

                            onClicked: {
                                if (root.activePlayer?.canGoPrevious)
                                    root.activePlayer.previous()
                            }
                        }
                    }

                    Text {
                        height: parent.height

                        verticalAlignment:
                            Text.AlignVCenter

                        text:
                            root.activePlayer?.isPlaying
                            ? "󰏤"
                            : "󰐊"

                        color:
                            playMouse.containsMouse
                            ? root.cyan
                            : root.text

                        font {
                            family: root.fontFamily
                            pixelSize: 16
                        }

                        MouseArea {
                            id: playMouse

                            anchors.fill: parent
                            anchors.margins: -4

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            enabled:
                                root.activePlayer?.canTogglePlaying
                                ?? false

                            onClicked: {
                                if (root.activePlayer?.canTogglePlaying)
                                    root.activePlayer.togglePlaying()
                            }
                        }
                    }

                    Text {
                        height: parent.height

                        verticalAlignment:
                            Text.AlignVCenter

                        text: "󰒭"

                        color:
                            nextMouse.containsMouse
                            ? root.blue
                            : root.muted

                        font {
                            family: root.fontFamily
                            pixelSize: 16
                        }

                        MouseArea {
                            id: nextMouse

                            anchors.fill: parent
                            anchors.margins: -4

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            enabled:
                                root.activePlayer?.canGoNext
                                ?? false

                            onClicked: {
                                if (root.activePlayer?.canGoNext)
                                    root.activePlayer.next()
                            }
                        }
                    }
                }

                Rectangle {
                    visible: mediaRow.visible

                    anchors.verticalCenter:
                        parent.verticalCenter

                    width: 1
                    height: 14

                    color: root.border
                }

                // audio
                Item {
                    id: audioItem

                    width: audioRow.implicitWidth
                    height: 36

                    Row {
                        id: audioRow

                        anchors.centerIn: parent

                        height: 36
                        spacing: 6

                        Text {
                            height: parent.height

                            verticalAlignment:
                                Text.AlignVCenter

                            text: {
                                if (
                                    !bar.audioSink
                                    || !bar.audioSink.audio
                                )
                                    return "󰖁"

                                if (bar.audioSink.audio.muted)
                                    return "󰝟"

                                const volume =
                                    bar.audioSink.audio.volume

                                if (volume < 0.34)
                                    return "󰕿"

                                if (volume < 0.67)
                                    return "󰖀"

                                return "󰕾"
                            }

                            color: {
                                if (
                                    !bar.audioSink?.audio
                                    || bar.audioSink.audio.muted
                                )
                                    return root.muted

                                return audioMouse.containsMouse
                                    ? root.cyan
                                    : root.blue
                            }

                            font {
                                family: root.fontFamily
                                pixelSize: 16
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }
                        }

                        Text {
                            height: parent.height

                            verticalAlignment:
                                Text.AlignVCenter

                            text: {
                                if (
                                    !bar.audioSink
                                    || !bar.audioSink.audio
                                )
                                    return "--"

                                return Math.round(
                                    bar.audioSink.audio.volume
                                    * 100
                                ) + "%"
                            }

                            color: root.text

                            font {
                                family: root.fontFamily
                                pixelSize: 12
                                weight: Font.Medium
                            }
                        }
                    }

                    MouseArea {
                        id: audioMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        acceptedButtons:
                            Qt.LeftButton
                            | Qt.RightButton

                        onClicked: mouse => {
                            if (mouse.button === Qt.RightButton) {
                                if (bar.audioSink?.audio) {
                                    bar.audioSink.audio.muted =
                                        !bar.audioSink.audio.muted
                                }

                                return
                            }

                            calendarPopup.visible = false
                            mediaPopup.visible = false
                            powerPopup.visible = false

                            audioPopup.showAt(audioItem)
                        }

                        onWheel: wheel => {
                            if (!bar.audioSink?.audio)
                                return

                            const step =
                                wheel.angleDelta.y > 0
                                ? 0.05
                                : -0.05

                            bar.audioSink.audio.volume =
                                Math.max(
                                    0,
                                    Math.min(
                                        1,
                                        bar.audioSink.audio.volume
                                            + step
                                    )
                                )
                        }
                    }
                }

                // sys tray
                Row {
                    height: 36
                    spacing: 9

                    Repeater {
                        model: SystemTray.items

                        Item {
                            id: trayDelegate

                            required property var modelData

                            readonly property var trayItem:
                                modelData

                            width: 20
                            height: 36

                            function openMenu() {
                                if (!trayItem.hasMenu)
                                    return

                                const point =
                                    trayDelegate.mapToItem(
                                        bar.contentItem,
                                        0,
                                        trayDelegate.height
                                    )

                                trayItem.display(
                                    bar,
                                    Math.round(point.x),
                                    bar.height
                                )
                            }

                            Image {
                                anchors.centerIn: parent

                                width: 17
                                height: 17

                                source: trayItem.icon

                                sourceSize.width: 17
                                sourceSize.height: 17

                                fillMode:
                                    Image.PreserveAspectFit

                                opacity:
                                    trayMouse.containsMouse
                                    ? 1
                                    : 0.85

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 100
                                    }
                                }
                            }

                            MouseArea {
                                id: trayMouse

                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    Qt.PointingHandCursor

                                acceptedButtons:
                                    Qt.LeftButton
                                    | Qt.MiddleButton
                                    | Qt.RightButton

                                onClicked: mouse => {
                                    if (
                                        mouse.button
                                        === Qt.RightButton
                                    ) {
                                        trayDelegate.openMenu()
                                    } else if (
                                        mouse.button
                                        === Qt.MiddleButton
                                    ) {
                                        trayItem.secondaryActivate()
                                    } else if (
                                        trayItem.onlyMenu
                                        && trayItem.hasMenu
                                    ) {
                                        trayDelegate.openMenu()
                                    } else {
                                        trayItem.activate()
                                    }
                                }

                                onWheel: wheel => {
                                    trayItem.scroll(
                                        wheel.angleDelta.y,
                                        false
                                    )
                                }
                            }
                        }
                    }
                }

                // notifications
                Item {
                    width: 24
                    height: 36

                    Text {
                        anchors.centerIn: parent

                        text: {
                            const dnd =
                                root.notificationState
                                    .indexOf("dnd") !== -1

                            if (dnd) {
                                return root.notificationCount > 0
                                    ? "󰂠"
                                    : "󰪓"
                            }

                            return root.notificationCount > 0
                                ? "󱅫"
                                : "󰂜"
                        }

                        color: {
                            if (notificationMouse.containsMouse)
                                return root.cyan

                            return root.notificationCount > 0
                                ? root.blue
                                : root.muted
                        }

                        font {
                            family: root.fontFamily
                            pixelSize: 16
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }

                    MouseArea {
                        id: notificationMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        cursorShape:
                            Qt.PointingHandCursor

                        acceptedButtons:
                            Qt.LeftButton
                            | Qt.RightButton

                        onClicked: mouse => {
                            calendarPopup.visible = false
                            audioPopup.visible = false
                            mediaPopup.visible = false
                            powerPopup.visible = false

                            if (
                                mouse.button
                                === Qt.RightButton
                            ) {
                                Quickshell.execDetached([
                                    "swaync-client",
                                    "-d",
                                    "-sw"
                                ])
                            } else {
                                Quickshell.execDetached([
                                    "swaync-client",
                                    "-t",
                                    "-sw"
                                ])
                            }
                        }
                    }
                }

                // power
                Item {
                    width: 24
                    height: 36

                    Text {
                        anchors.centerIn: parent

                        text: "󰐥"

                        color:
                            powerMouse.containsMouse
                            ? root.red
                            : root.muted

                        font {
                            family: root.fontFamily
                            pixelSize: 16
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }

                    MouseArea {
                        id: powerMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        cursorShape:
                            Qt.PointingHandCursor

                        onClicked: {
                            calendarPopup.visible = false
                            audioPopup.visible = false
                            mediaPopup.visible = false

                            powerPopup.visible =
                                !powerPopup.visible
                        }
                    }
                }
            }

            // popups
            CalendarPopup {
                id: calendarPopup

                barWindow: bar
            }

            AudioPopup {
                id: audioPopup

                barWindow: bar

                sink: bar.audioSink
                source: bar.audioSource
            }

            MediaPopup {
                id: mediaPopup

                barWindow: bar
                player: root.activePlayer
            }

            // power popup
            PopupWindow {
                id: powerPopup

                anchor.window: bar

                anchor.rect.x:
                    bar.width - width - 10

                anchor.rect.y:
                    bar.height + 6

                implicitWidth: 240
                implicitHeight: 160

                visible: false
                grabFocus: true

                color: "transparent"

                Rectangle {
                    anchors.fill: parent

                    color: root.surface

                    border.width: 1
                    border.color: root.border

                    radius: 3

                    Column {
                        anchors {
                            fill: parent
                            margins: 10
                        }

                        spacing: 8

                        Text {
                            text: "SESSION"

                            color: root.muted

                            font {
                                family: root.fontFamily
                                pixelSize: 10
                                weight: Font.DemiBold
                                letterSpacing: 1
                            }
                        }

                        Grid {
                            columns: 2
                            spacing: 5

                            Repeater {
                                model: [
                                    {
                                        label: "Lock",
                                        icon: "󰌾",
                                        command: ["hyprlock"]
                                    },
                                    {
                                        label: "Suspend",
                                        icon: "󰤄",
                                        command: [
                                            "systemctl",
                                            "suspend"
                                        ]
                                    },
                                    {
                                        label: "Logout",
                                        icon: "󰍃",
                                        command: [
                                            "hyprctl",
                                            "dispatch",
                                            "exit"
                                        ]
                                    },
                                    {
                                        label: "Reboot",
                                        icon: "󰜉",
                                        command: [
                                            "systemctl",
                                            "reboot"
                                        ]
                                    },
                                    {
                                        label: "Shutdown",
                                        icon: "󰐥",
                                        command: [
                                            "systemctl",
                                            "poweroff"
                                        ],
                                        destructive: true
                                    }
                                ]

                                Rectangle {
                                    required property var modelData

                                    width: 107
                                    height: 40

                                    radius: 3

                                    color:
                                        actionMouse.containsMouse
                                        ? root.surfaceHover
                                        : "transparent"

                                    Row {
                                        anchors {
                                            left: parent.left
                                            leftMargin: 10

                                            verticalCenter:
                                                parent.verticalCenter
                                        }

                                        spacing: 8

                                        Text {
                                            text: modelData.icon

                                            color:
                                                modelData.destructive
                                                === true
                                                ? root.red
                                                : root.blue

                                            font {
                                                family:
                                                    root.fontFamily

                                                pixelSize: 15
                                            }
                                        }

                                        Text {
                                            text:
                                                modelData.label

                                            color: root.text

                                            font {
                                                family:
                                                    root.fontFamily

                                                pixelSize: 11
                                                weight:
                                                    Font.Medium
                                            }
                                        }
                                    }

                                    MouseArea {
                                        id: actionMouse

                                        anchors.fill: parent

                                        hoverEnabled: true

                                        cursorShape:
                                            Qt.PointingHandCursor

                                        onClicked: {
                                            powerPopup.visible =
                                                false

                                            Quickshell.execDetached(
                                                modelData.command
                                            )
                                        }
                                    }

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
