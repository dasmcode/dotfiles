import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

// A single service owner shared by every monitor; no per-bar shell polling.
Scope {
    id: root
    property string openPopup: ""
    property var popupOwner: null
    readonly property date now: clock.date
    readonly property var player: Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0] ?? null
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink && sink.ready ? sink.audio : null
    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery && battery.ready && battery.isPresent && battery.isLaptopBattery
    readonly property bool onBattery: UPower.onBattery
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var bluetoothDevices: adapter ? adapter.devices.values : []
    readonly property var connectedBluetoothDevices: bluetoothDevices.filter(d => d.connected)
    readonly property var pairedBluetoothDevices: bluetoothDevices.filter(d => d.paired && !d.connected)
    readonly property var nearbyBluetoothDevices: bluetoothDevices.filter(d => !d.paired && !d.connected)
    readonly property var wifiDevices: Networking.devices.values.filter(d => d.type === DeviceType.Wifi)
    readonly property var wifiNetworks: {
        const networks = [];
        for (const device of wifiDevices) {
            for (const network of device.networks.values) networks.push(network);
        }
        return networks.sort((a, b) => b.signalStrength - a.signalStrength);
    }
    readonly property var currentWifiNetwork: wifiNetworks.find(network => network.connected) ?? null
    readonly property var connectedNetworks: {
        const result = [];
        for (const device of Networking.devices.values) {
            for (const network of device.networks.values) {
                if (network.connected) result.push(network);
            }
        }
        return result;
    }
    readonly property string networkLabel: connectedNetworks.map(n => n.name).join(" · ") || "Offline"

    SystemClock { id: clock; precision: SystemClock.Minutes }
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }

    function togglePopup(owner, name) {
        if (popupOwner === owner && openPopup === name) {
            closePopup();
        } else {
            openPopup = "";
            popupOwner = owner;
            openPopup = name;
        }
    }
    function closePopup() { openPopup = ""; popupOwner = null; }
    function startWifiScan() {
        for (const device of wifiDevices) device.scannerEnabled = true;
    }
    function stopWifiScan() {
        for (const device of wifiDevices) device.scannerEnabled = false;
    }
    function toggleMute() { if (audio) audio.muted = !audio.muted; }
    function changeVolume(delta) {
        if (audio) audio.volume = Math.max(0, Math.min(1, audio.volume + delta));
    }
    function launch(command) {
        closePopup();
        Quickshell.execDetached(command);
    }
}
