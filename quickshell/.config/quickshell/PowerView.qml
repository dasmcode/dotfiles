import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

ColumnLayout {
    id: root
    required property ShellState shellState
    implicitWidth: 334
    spacing: 14

    function duration(seconds) {
        const minutes = Math.round(seconds / 60);
        return Math.floor(minutes / 60) + "h " + (minutes % 60) + "m";
    }

    Text {
        text: "POWER"
        color: "#7ad9a8"
        font { family: "FiraCode Nerd Font"; pixelSize: 12; bold: true }
    }
    Text {
        Layout.fillWidth: true
        text: root.shellState.hasBattery ? root.shellState.batteryPercentage + "% · " + UPowerDeviceState.toString(root.shellState.battery.state) : "Connected to AC power"
        wrapMode: Text.Wrap
        color: "#f5e2c5"
        font { family: "FiraCode Nerd Font"; pixelSize: 18; bold: true }
    }
    Rectangle {
        visible: root.shellState.hasBattery
        Layout.fillWidth: true
        implicitHeight: 7
        radius: 4
        color: "#1d3631"
        Rectangle {
            width: parent.width * root.shellState.batteryFraction
            height: parent.height
            radius: 4
            color: "#7ad9a8"
        }
    }
    Text {
        Layout.fillWidth: true
        text: {
            if (!root.shellState.hasBattery) return "No laptop battery detected.\nThis desktop is running on mains power.";
            const battery = root.shellState.battery;
            const details = [root.shellState.onBattery ? "Running on battery" : "External power connected"];
            if (battery.timeToEmpty > 0) details.push(root.duration(battery.timeToEmpty) + " remaining");
            if (battery.timeToFull > 0) details.push(root.duration(battery.timeToFull) + " until full");
            if (battery.healthSupported) details.push("Battery health: " + root.shellState.batteryHealthPercentage + "%");
            return details.join("\n");
        }
        wrapMode: Text.Wrap
        color: "#8fa79d"
        font { family: "FiraCode Nerd Font"; pixelSize: 13 }
    }
    Pill {
        label: "System monitor"; icon: "󰍛"
        Layout.alignment: Qt.AlignHCenter
        onClicked: root.shellState.launch(["kitty", "--title", "System monitor", "btop"])
    }
}
