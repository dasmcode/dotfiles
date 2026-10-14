import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

Rectangle {
    id: root
    required property var device
    property bool showForget: true

    Layout.fillWidth: true
    implicitHeight: 54
    radius: 12
    color: "#0a1714"
    border.width: 1
    border.color: device.connected ? "#285242" : "#1e352d"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 8
        spacing: 8
        Text {
            text: device.connected ? "󰂱" : "󰂯"
            color: device.connected ? "#3dd1b0" : "#f5cd5b"
            font { family: "FiraCode Nerd Font"; pixelSize: 19 }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1
            Text {
                Layout.fillWidth: true
                text: root.device.name || root.device.deviceName || "Unknown device"
                color: "#f5e2c5"
                elide: Text.ElideRight
                font { family: "FiraCode Nerd Font"; pixelSize: 11; bold: true }
            }
            Text {
                Layout.fillWidth: true
                text: root.device.blocked ? "Blocked" : root.device.connected ? "Connected" + (root.device.batteryAvailable ? " · " + Math.round(root.device.battery) + "% battery" : "") : root.device.pairing ? "Pairing…" : root.device.paired ? BluetoothDeviceState.toString(root.device.state) : "Available nearby"
                color: root.device.connected ? "#3dd1b0" : "#8fa79d"
                elide: Text.ElideRight
                font { family: "FiraCode Nerd Font"; pixelSize: 9 }
            }
        }
        Pill {
            label: root.device.blocked ? "Unblock" : root.device.pairing ? "Cancel" : root.device.connected ? "Disconnect" : root.device.paired ? "Connect" : "Pair"
            onClicked: {
                if (root.device.blocked) root.device.blocked = false;
                else if (root.device.pairing) root.device.cancelPair();
                else if (root.device.connected) root.device.disconnect();
                else if (root.device.paired) root.device.connect();
                else root.device.pair();
            }
        }
        Pill {
            visible: root.showForget && root.device.paired && !root.device.connected
            label: "Forget"
            onClicked: root.device.forget()
        }
    }
}
