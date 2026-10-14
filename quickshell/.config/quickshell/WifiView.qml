import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Networking

ColumnLayout {
    id: root
    required property ShellState shellState
    property var selectedNetwork: null
    property var attemptedNetwork: null
    property bool showPassword: false
    property string statusMessage: ""
    property string errorMessage: ""

    readonly property var currentNetwork: shellState.currentWifiNetwork
    readonly property var availableNetworks: shellState.wifiNetworks.filter(network => !network.connected)
    readonly property bool selectedNetworkIsEnterprise: selectedNetwork && (selectedNetwork.security === WifiSecurityType.WpaEap || selectedNetwork.security === WifiSecurityType.Wpa2Eap || selectedNetwork.security === WifiSecurityType.Wpa3SuiteB192)

    implicitWidth: 390
    spacing: 12

    function signalPercent(network) {
        return Math.round(Math.max(0, Math.min(1, network.signalStrength)) * 100);
    }

    function scan() {
        if (!Networking.wifiEnabled) return;
        shellState.startWifiScan();
        scanTimeout.restart();
    }

    function stopScan() {
        scanTimeout.stop();
        shellState.stopWifiScan();
    }

    function openPasswordPrompt(network) {
        selectedNetwork = network;
        showPassword = false;
        errorMessage = "";
        passwordField.text = "";
        if (!selectedNetworkIsEnterprise)
            Qt.callLater(() => passwordField.forceActiveFocus());
    }

    function connectNetwork(network) {
        if (network.known || network.security === WifiSecurityType.Open || network.security === WifiSecurityType.Owe) {
            selectedNetwork = null;
            errorMessage = "";
            attemptedNetwork = network;
            statusMessage = "Connecting to " + network.name + "…";
            network.connect();
        } else {
            openPasswordPrompt(network);
        }
    }

    function submitPassword() {
        if (!selectedNetwork || passwordField.text.length === 0) {
            errorMessage = "Enter the network password to continue.";
            return;
        }
        attemptedNetwork = selectedNetwork;
        errorMessage = "";
        statusMessage = "Connecting to " + selectedNetwork.name + "…";
        selectedNetwork.connectWithPsk(passwordField.text);
    }

    function forgetNetwork(network) {
        network.forget();
        if (selectedNetwork === network) selectedNetwork = null;
    }

    Component.onCompleted: scan()
    Component.onDestruction: stopScan()

    Timer {
        id: scanTimeout
        interval: 12000
        onTriggered: root.shellState.stopWifiScan()
    }

    Connections {
        target: root.attemptedNetwork
        function onConnectionFailed(reason) {
            switch (reason) {
            case ConnectionFailReason.NoSecrets:
                root.openPasswordPrompt(root.attemptedNetwork);
                root.errorMessage = root.selectedNetworkIsEnterprise ? "Open Network Settings to enter the required credentials." : "Enter the password for this network.";
                break;
            case ConnectionFailReason.WifiAuthTimeout: root.errorMessage = "Authentication failed. Check the password and try again."; break;
            case ConnectionFailReason.WifiNetworkLost: root.errorMessage = "The network was lost. Try connecting again."; break;
            case ConnectionFailReason.WifiClientDisconnected: root.errorMessage = "The connection was interrupted."; break;
            default: root.errorMessage = "Could not connect to this network.";
            }
            root.statusMessage = "Connection failed";
        }
        function onConnectedChanged() {
            if (root.attemptedNetwork && root.attemptedNetwork.connected) {
                root.statusMessage = "Connected to " + root.attemptedNetwork.name;
                root.errorMessage = "";
                root.selectedNetwork = null;
                passwordField.text = "";
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
                text: ""
                color: "#3dd1b0"
                font { family: "FiraCode Nerd Font"; pixelSize: 21 }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: "Wi-Fi"
                color: "#f5e2c5"
                font { family: "FiraCode Nerd Font"; pixelSize: 17; bold: true }
            }
            Text {
                Layout.fillWidth: true
                text: !Networking.wifiHardwareEnabled ? "Wi-Fi hardware unavailable" : !Networking.wifiEnabled ? "Turned off" : root.currentNetwork ? "Connected to " + root.currentNetwork.name : root.statusMessage || "Not connected"
                color: root.errorMessage ? "#ff8e7e" : "#8fa79d"
                elide: Text.ElideRight
                font { family: "FiraCode Nerd Font"; pixelSize: 11 }
            }
        }
        Rectangle {
            id: wifiSwitch
            Layout.preferredWidth: 54
            Layout.preferredHeight: 30
            radius: 15
            color: Networking.wifiEnabled ? "#256d59" : "#26332f"
            opacity: Networking.wifiHardwareEnabled ? 1 : 0.45
            Rectangle {
                id: wifiThumb
                x: Networking.wifiEnabled ? wifiSwitch.width - width - 4 : 4
                y: 4
                width: 22
                height: 22
                radius: 11
                color: "#f5e2c5"
                Behavior on x { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
            }
            MouseArea {
                anchors.fill: parent
                enabled: Networking.wifiHardwareEnabled
                cursorShape: Qt.PointingHandCursor
                onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
            }
        }
    }

    Rectangle {
        visible: root.currentNetwork !== null && Networking.wifiEnabled
        Layout.fillWidth: true
        implicitHeight: 74
        radius: 14
        color: "#10231f"
        border.width: 1
        border.color: "#285242"
        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            Text {
                text: "󰤨"
                color: "#3dd1b0"
                font { family: "FiraCode Nerd Font"; pixelSize: 21 }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    Layout.fillWidth: true
                    text: root.currentNetwork ? root.currentNetwork.name : ""
                    color: "#f5e2c5"
                    elide: Text.ElideRight
                    font { family: "FiraCode Nerd Font"; pixelSize: 13; bold: true }
                }
                Text {
                    text: "Connected · " + (root.currentNetwork ? root.signalPercent(root.currentNetwork) + "% signal" : "")
                    color: "#8fa79d"
                    font { family: "FiraCode Nerd Font"; pixelSize: 10 }
                }
            }
            Pill {
                label: "Disconnect"
                onClicked: {
                    root.currentNetwork.disconnect();
                    root.statusMessage = "Disconnecting…";
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: "AVAILABLE NETWORKS"
            color: "#f5cd5b"
            font { family: "FiraCode Nerd Font"; pixelSize: 11; bold: true }
        }
        Text {
            visible: Networking.wifiEnabled && root.shellState.wifiDevices.length === 0
            text: "No Wi-Fi adapter"
            color: "#8fa79d"
            font { family: "FiraCode Nerd Font"; pixelSize: 10 }
        }
        Pill {
            label: scanTimeout.running ? "Scanning…" : "Scan"
            enabled: Networking.wifiEnabled
            onClicked: root.scan()
        }
    }

    Text {
        visible: !Networking.wifiEnabled
        Layout.fillWidth: true
        text: "Turn on Wi-Fi to see nearby networks."
        color: "#8fa79d"
        wrapMode: Text.Wrap
        font { family: "FiraCode Nerd Font"; pixelSize: 11 }
    }

    ScrollView {
        id: networkScroll
        visible: Networking.wifiEnabled
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(networkList.implicitHeight, 230)
        clip: true
        contentWidth: availableWidth
        ColumnLayout {
            id: networkList
            width: networkScroll.availableWidth
            spacing: 5
            Repeater {
                model: root.availableNetworks
                Rectangle {
                    id: networkRow
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 52
                    radius: 11
                    color: "#0a1714"
                    border.width: 1
                    border.color: "#1e352d"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 8
                        spacing: 8
                        Text {
                            text: root.signalPercent(networkRow.modelData) >= 65 ? "󰤨" : root.signalPercent(networkRow.modelData) >= 35 ? "󰤥" : "󰤟"
                            color: "#3dd1b0"
                            font { family: "FiraCode Nerd Font"; pixelSize: 18 }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text {
                                Layout.fillWidth: true
                                text: networkRow.modelData.name || "Hidden network"
                                color: "#f5e2c5"
                                elide: Text.ElideRight
                                font { family: "FiraCode Nerd Font"; pixelSize: 11; bold: true }
                            }
                            Text {
                                text: networkRow.modelData.known ? "Saved · " + root.signalPercent(networkRow.modelData) + "%" : networkRow.modelData.security === WifiSecurityType.Open || networkRow.modelData.security === WifiSecurityType.Owe ? "Open network" : "Secured network"
                                color: "#8fa79d"
                                font { family: "FiraCode Nerd Font"; pixelSize: 9 }
                            }
                        }
                        Pill {
                            label: networkRow.modelData.stateChanging ? "Connecting…" : "Connect"
                            enabled: !networkRow.modelData.stateChanging
                            onClicked: root.connectNetwork(networkRow.modelData)
                        }
                        Pill {
                            visible: networkRow.modelData.known
                            label: "Forget"
                            onClicked: root.forgetNetwork(networkRow.modelData)
                        }
                    }
                }
            }
        }
    }

    Text {
        visible: Networking.wifiEnabled && root.availableNetworks.length === 0
        Layout.fillWidth: true
        text: scanTimeout.running ? "Looking for nearby networks…" : "No networks found. Try scanning again or open network settings."
        color: "#8fa79d"
        wrapMode: Text.Wrap
        font { family: "FiraCode Nerd Font"; pixelSize: 11 }
    }

    Rectangle {
        visible: root.selectedNetwork !== null
        Layout.fillWidth: true
        implicitHeight: passwordColumn.implicitHeight + 20
        radius: 14
        color: "#10231f"
        border.width: 1
        border.color: "#285242"
        ColumnLayout {
            id: passwordColumn
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8
            Text {
                Layout.fillWidth: true
                text: root.selectedNetworkIsEnterprise ? "Enterprise network · " + root.selectedNetwork.name : "Connect to " + root.selectedNetwork?.name
                color: "#f5e2c5"
                elide: Text.ElideRight
                font { family: "FiraCode Nerd Font"; pixelSize: 12; bold: true }
            }
            Text {
                visible: root.selectedNetworkIsEnterprise
                Layout.fillWidth: true
                text: "This network requires identity or certificate settings. Open Network Settings to finish connecting."
                color: "#8fa79d"
                wrapMode: Text.Wrap
                font { family: "FiraCode Nerd Font"; pixelSize: 10 }
            }
            RowLayout {
                visible: !root.selectedNetworkIsEnterprise
                Layout.fillWidth: true
                spacing: 6
                TextField {
                    id: passwordField
                    Layout.fillWidth: true
                    placeholderText: "Wi-Fi password"
                    echoMode: root.showPassword ? TextInput.Normal : TextInput.Password
                    color: "#f5e2c5"
                    selectionColor: "#3dd1b0"
                    selectedTextColor: "#040e0d"
                    inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                    maximumLength: 256
                    onAccepted: root.submitPassword()
                    background: Rectangle {
                        radius: 9
                        color: "#07120f"
                        border.width: 1
                        border.color: passwordField.activeFocus ? "#3dd1b0" : "#294b40"
                    }
                }
                Pill {
                    label: root.showPassword ? "Hide" : "Show"
                    onClicked: root.showPassword = !root.showPassword
                }
            }
            Text {
                visible: root.errorMessage !== ""
                Layout.fillWidth: true
                text: root.errorMessage
                color: "#ff8e7e"
                wrapMode: Text.Wrap
                font { family: "FiraCode Nerd Font"; pixelSize: 10 }
            }
            RowLayout {
                Layout.fillWidth: true
                Item { Layout.fillWidth: true }
                Pill {
                    label: "Cancel"
                    onClicked: { root.selectedNetwork = null; root.errorMessage = ""; }
                }
                Pill {
                    visible: root.selectedNetworkIsEnterprise
                    label: "Open Settings"
                    onClicked: root.shellState.launch(["nm-connection-editor"])
                }
                Pill {
                    visible: !root.selectedNetworkIsEnterprise
                    label: root.selectedNetwork?.stateChanging ? "Connecting…" : "Connect"
                    enabled: root.selectedNetwork !== null && !root.selectedNetwork.stateChanging
                    onClicked: root.submitPassword()
                }
            }
        }
    }

    Text {
        visible: root.errorMessage !== "" && root.selectedNetwork === null
        Layout.fillWidth: true
        text: root.errorMessage
        color: "#ff8e7e"
        wrapMode: Text.Wrap
        font { family: "FiraCode Nerd Font"; pixelSize: 10 }
    }

    RowLayout {
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: root.statusMessage
            visible: text !== "" && root.errorMessage === ""
            color: "#8fa79d"
            elide: Text.ElideRight
            font { family: "FiraCode Nerd Font"; pixelSize: 10 }
        }
        Pill {
            label: "Network Settings"
            onClicked: root.shellState.launch(["nm-connection-editor"])
        }
    }
}
