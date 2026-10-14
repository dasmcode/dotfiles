import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

ColumnLayout {
    id: root
    required property ShellState shellState
    property bool scanRequested: false

    implicitWidth: 390
    spacing: 12

    function startScan() {
        if (!shellState.adapter || !shellState.adapter.enabled || shellState.adapter.discovering) return;
        shellState.adapter.discovering = true;
        scanRequested = true;
        scanTimeout.restart();
    }

    function stopScan() {
        scanTimeout.stop();
        if (scanRequested && shellState.adapter?.discovering)
            shellState.adapter.discovering = false;
        scanRequested = false;
    }

    Component.onCompleted: startScan()
    Component.onDestruction: stopScan()

    Timer {
        id: scanTimeout
        interval: 12000
        onTriggered: root.stopScan()
    }

    Connections {
        target: root.shellState.adapter
        function onEnabledChanged() {
            if (!root.shellState.adapter.enabled) root.stopScan();
            else root.startScan();
        }
        function onDiscoveringChanged() {
            if (!root.shellState.adapter.discovering) {
                root.scanRequested = false;
                scanTimeout.stop();
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 11
        Rectangle {
            Layout.preferredWidth: 42
            Layout.preferredHeight: 42
            radius: 14
            color: "#132a25"
            Text {
                anchors.centerIn: parent
                text: "󰂯"
                color: "#f5cd5b"
                font { family: "FiraCode Nerd Font"; pixelSize: 21 }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: "Bluetooth"
                color: "#f5e2c5"
                font { family: "FiraCode Nerd Font"; pixelSize: 17; bold: true }
            }
            Text {
                Layout.fillWidth: true
                text: !root.shellState.adapter ? "No Bluetooth adapter found" : !root.shellState.adapter.enabled ? "Turned off" : root.shellState.connectedBluetoothDevices.length > 0 ? "Connected to " + root.shellState.connectedBluetoothDevices.length + (root.shellState.connectedBluetoothDevices.length === 1 ? " device" : " devices") : "Ready to connect"
                color: "#8fa79d"
                elide: Text.ElideRight
                font { family: "FiraCode Nerd Font"; pixelSize: 11 }
            }
        }
        Rectangle {
            id: bluetoothSwitch
            Layout.preferredWidth: 54
            Layout.preferredHeight: 30
            radius: 15
            color: root.shellState.adapter?.enabled ? "#256d59" : "#26332f"
            opacity: root.shellState.adapter ? 1 : 0.45
            Rectangle {
                width: 22
                height: 22
                x: root.shellState.adapter?.enabled ? bluetoothSwitch.width - width - 4 : 4
                y: 4
                radius: 11
                color: "#f5e2c5"
                Behavior on x { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.shellState.adapter !== null
                cursorShape: Qt.PointingHandCursor
                onClicked: root.shellState.adapter.enabled = !root.shellState.adapter.enabled
            }
        }
    }

    Text {
        visible: !root.shellState.adapter
        Layout.fillWidth: true
        text: "No Bluetooth adapter is available on this system."
        color: "#8fa79d"
        wrapMode: Text.Wrap
        font { family: "FiraCode Nerd Font"; pixelSize: 11 }
    }

    RowLayout {
        visible: root.shellState.adapter?.enabled ?? false
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: "YOUR DEVICES"
            color: "#f5cd5b"
            font { family: "FiraCode Nerd Font"; pixelSize: 11; bold: true }
        }
        Pill {
            label: root.scanRequested ? "Stop" : root.shellState.adapter?.discovering ? "Scanning…" : "Scan"
            enabled: (root.shellState.adapter?.enabled ?? false) && (root.scanRequested || !root.shellState.adapter.discovering)
            onClicked: root.scanRequested ? root.stopScan() : root.startScan()
        }
    }

    ScrollView {
        visible: root.shellState.adapter?.enabled ?? false
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(deviceList.implicitHeight, 310)
        clip: true
        contentWidth: availableWidth
        ColumnLayout {
            id: deviceList
            width: parent.width
            spacing: 10
            ColumnLayout {
                visible: root.shellState.connectedBluetoothDevices.length > 0
                Layout.fillWidth: true
                spacing: 5
                Text {
                    text: "CONNECTED"
                    color: "#8fa79d"
                    font { family: "FiraCode Nerd Font"; pixelSize: 9; bold: true }
                }
                Repeater {
                    model: root.shellState.connectedBluetoothDevices
                    BluetoothDeviceRow { required property var modelData; device: modelData; showForget: false }
                }
            }
            ColumnLayout {
                visible: root.shellState.pairedBluetoothDevices.length > 0
                Layout.fillWidth: true
                spacing: 5
                Text {
                    text: "PAIRED DEVICES"
                    color: "#8fa79d"
                    font { family: "FiraCode Nerd Font"; pixelSize: 9; bold: true }
                }
                Repeater {
                    model: root.shellState.pairedBluetoothDevices
                    BluetoothDeviceRow { required property var modelData; device: modelData }
                }
            }
            ColumnLayout {
                visible: root.shellState.nearbyBluetoothDevices.length > 0
                Layout.fillWidth: true
                spacing: 5
                Text {
                    text: "AVAILABLE NEARBY"
                    color: "#8fa79d"
                    font { family: "FiraCode Nerd Font"; pixelSize: 9; bold: true }
                }
                Repeater {
                    model: root.shellState.nearbyBluetoothDevices
                    BluetoothDeviceRow { required property var modelData; device: modelData; showForget: false }
                }
            }
        }
    }

    Text {
        visible: root.shellState.adapter?.enabled && root.shellState.bluetoothDevices.length === 0
        Layout.fillWidth: true
        text: root.scanRequested || root.shellState.adapter?.discovering ? "Looking for nearby devices…" : "No devices found. Scan to search for nearby Bluetooth devices."
        color: "#8fa79d"
        wrapMode: Text.Wrap
        font { family: "FiraCode Nerd Font"; pixelSize: 11 }
    }

    RowLayout {
        visible: root.shellState.adapter?.enabled ?? false
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: "Pairing may require confirmation on the device."
            color: "#8fa79d"
            wrapMode: Text.Wrap
            font { family: "FiraCode Nerd Font"; pixelSize: 9 }
        }
        Pill {
            label: "Bluetooth Settings"
            onClicked: root.shellState.launch(["gnome-control-center", "bluetooth"])
        }
    }
}
