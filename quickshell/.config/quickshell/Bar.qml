import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: bar
    required property ShellState shellState
    anchors { top: true; left: true; right: true }
    margins { top: 13; left: 10; right: 10 }
    implicitHeight: 33
    color: "transparent"
    readonly property bool compact: width < 1400
    readonly property bool popupOpen: shellState.popupOwner === bar && shellState.openPopup !== ""
    property Item popupItem: clockPill

    function togglePopup(item, name) {
        popupItem = item;
        shellState.togglePopup(bar, name);
    }
    Component.onDestruction: { if (shellState && shellState.popupOwner === bar) shellState.closePopup(); }

    Pill {
        id: mediaPill
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 4
        icon: "󰎇"
        maxLabelWidth: Math.max(0, Math.min(240, centerGroup.x - x - 65))
        label: bar.compact ? "" : bar.shellState.player ? [bar.shellState.player.trackArtist, bar.shellState.player.trackTitle].filter(Boolean).join(" — ") || bar.shellState.player.identity : "Nothing playing"
        tooltip: "Media player"
        active: bar.popupOpen && bar.shellState.openPopup === "media"
        onClicked: bar.togglePopup(mediaPill, "media")
        onMiddleClicked: { if (bar.shellState.player?.canTogglePlaying) bar.shellState.player.togglePlaying(); }
    }

    RowLayout {
        id: centerGroup
        anchors.centerIn: parent
        spacing: 8
        Pill {
            id: clockPill
            icon: ""
            label: Qt.formatDateTime(bar.shellState.now, "HH:mm")
            tooltip: "Clock"
            active: bar.popupOpen && bar.shellState.openPopup === "calendar"
            onClicked: bar.togglePopup(clockPill, "calendar")
        }
        Workspaces { screen: bar.screen }
    }

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 4
        spacing: bar.compact ? 5 : 8
        Pill {
            icon: bar.shellState.audio?.muted ? "󰝟" : ""
            label: bar.shellState.audio ? bar.shellState.audio.muted ? "Muted" : Math.round(bar.shellState.audio.volume * 100) + "%" : "N/A"
            iconColor: "#3dd1b0"
            tooltip: "Volume"
            onClicked: bar.shellState.launch(["pavucontrol"])
            onRightClicked: bar.shellState.toggleMute()
            onMiddleClicked: bar.shellState.toggleMute()
            onScrolled: delta => bar.shellState.changeVolume(delta > 0 ? 0.05 : -0.05)
        }
        Pill {
            id: powerPill
            icon: bar.shellState.hasBattery ? "󰁹" : "󰚥"
            label: bar.shellState.hasBattery ? Math.round(bar.shellState.battery.percentage) + "%" : "AC"
            iconColor: bar.shellState.hasBattery && bar.shellState.battery.percentage < 20 ? "#ff6048" : "#7ad9a8"
            tooltip: "Power"
            active: bar.popupOpen && bar.shellState.openPopup === "power"
            onClicked: bar.togglePopup(powerPill, "power")
        }
        Pill {
            id: bluetoothPill
            icon: "󰂯"
            label: bar.compact ? "" : !bar.shellState.adapter ? "N/A" : bar.shellState.adapter.enabled ? "on" : "off"
            iconColor: "#f5cd5b"
            tooltip: "Bluetooth"
            active: bar.popupOpen && bar.shellState.openPopup === "bluetooth"
            onClicked: bar.togglePopup(bluetoothPill, "bluetooth")
            onRightClicked: { if (bar.shellState.adapter) bar.shellState.adapter.enabled = !bar.shellState.adapter.enabled; }
        }
        Pill {
            id: wifiPill
            icon: ""
            label: bar.compact ? "" : bar.shellState.networkLabel
            maxLabelWidth: Math.max(40, Math.min(160, (bar.width - 1400) / 2))
            iconColor: "#ff6048"
            tooltip: "Network"
            active: bar.popupOpen && bar.shellState.openPopup === "wifi"
            onClicked: bar.togglePopup(wifiPill, "wifi")
        }
    }

    PopupWindow {
        id: popup
        visible: bar.popupOpen
        anchor.item: bar.popupItem
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.margins.top: 10
        implicitWidth: content.implicitWidth + 24
        implicitHeight: content.implicitHeight + 24
        color: "transparent"
        grabFocus: true
        onClosed: {
            if (bar.shellState.popupOwner === bar)
                bar.shellState.closePopup();
        }

        Rectangle {
            anchors.fill: parent
            radius: 20
            color: "#040e0d"
            border.width: 1
            border.color: "#294b40"
            focus: true
            Keys.onEscapePressed: bar.shellState.closePopup()
            Loader {
                id: content
                anchors.centerIn: parent
                sourceComponent: {
                    if (!bar.popupOpen) return null;
                    switch (bar.shellState.openPopup) {
                    case "calendar": return calendarComponent;
                    case "media": return mediaComponent;
                    case "power": return powerComponent;
                    case "bluetooth": return bluetoothComponent;
                    case "wifi": return wifiComponent;
                    default: return null;
                    }
                }
            }
        }
    }

    Component { id: calendarComponent; CalendarView {} }
    Component { id: mediaComponent; MediaView { shellState: bar.shellState } }
    Component { id: powerComponent; PowerView { shellState: bar.shellState } }
    Component { id: bluetoothComponent; BluetoothView { shellState: bar.shellState } }
    Component { id: wifiComponent; WifiView { shellState: bar.shellState } }
}
