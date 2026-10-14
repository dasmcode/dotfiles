import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property ShellState shellState
    readonly property var player: shellState.player
    implicitWidth: 334
    spacing: 14

    Text {
        text: "NOW PLAYING"
        color: "#3dd1b0"
        font { family: "FiraCode Nerd Font"; pixelSize: 12; bold: true }
    }
    Text {
        Layout.fillWidth: true
        text: root.player ? root.player.trackTitle || "Unknown track" : "Nothing playing"
        textFormat: Text.PlainText
        wrapMode: Text.Wrap
        maximumLineCount: 3
        elide: Text.ElideRight
        color: "#f5e2c5"
        font { family: "FiraCode Nerd Font"; pixelSize: 18; bold: true }
    }
    Text {
        Layout.fillWidth: true
        text: root.player ? [root.player.trackArtist, root.player.identity].filter(Boolean).join(" · ") : "Start music in an MPRIS-compatible player."
        textFormat: Text.PlainText
        wrapMode: Text.Wrap
        maximumLineCount: 3
        elide: Text.ElideRight
        color: "#8fa79d"
        font { family: "FiraCode Nerd Font"; pixelSize: 12 }
    }
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 12
        Pill {
            icon: "󰒮"; tooltip: "Previous track"
            enabled: root.player?.canGoPrevious ?? false
            onClicked: root.player.previous()
        }
        Pill {
            icon: root.player?.isPlaying ? "󰏤" : "󰐊"
            tooltip: root.player?.isPlaying ? "Pause" : "Play"
            enabled: root.player?.canTogglePlaying ?? false
            onClicked: root.player.togglePlaying()
        }
        Pill {
            icon: "󰒭"; tooltip: "Next track"
            enabled: root.player?.canGoNext ?? false
            onClicked: root.player.next()
        }
    }
    Pill {
        Layout.alignment: Qt.AlignHCenter
        label: "Open player"; icon: "󰎇"
        enabled: root.player?.canRaise ?? false
        onClicked: { root.player.raise(); root.shellState.closePopup(); }
    }
}
