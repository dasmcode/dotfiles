import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    required property ShellScreen screen

    // Workspaces are already backed by Hyprland's live ObjectModel. Keep them
    // in a Repeater so monitor hot-plugging and workspace moves stay reactive.
    function activate(workspace) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + workspace.id + " })");
    }

    implicitWidth: row.implicitWidth + 16
    implicitHeight: 33
    radius: height / 2
    color: "#040e0d"

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 2
        Repeater {
            id: workspaceRepeater
            model: Hyprland.workspaces
            Item {
                id: workspaceButton
                required property var modelData
                readonly property bool belongsToScreen: modelData.id > 0 && modelData.monitor && modelData.monitor.name === root.screen.name
                visible: belongsToScreen
                implicitWidth: visible ? 26 : 0
                implicitHeight: visible ? 29 : 0
                property bool tooltipOpen: false
                TextMetrics {
                    id: tooltipMetrics
                    font: tooltipText.font
                    text: "Workspace " + workspaceButton.modelData.name
                }
                Timer {
                    id: tooltipDelay
                    interval: 550
                    onTriggered: workspaceButton.tooltipOpen = workspaceButton.visible
                }
                PopupWindow {
                    id: tooltipPopup
                    visible: workspaceButton.tooltipOpen
                    anchor.item: workspaceButton
                    anchor.edges: Edges.Bottom
                    anchor.gravity: Edges.Bottom
                    anchor.margins.top: 8
                    color: "transparent"
                    implicitWidth: tooltipMetrics.width + 24
                    implicitHeight: tooltipText.implicitHeight + 18
                    Rectangle {
                        anchors.fill: parent
                        radius: 9
                        color: "#10231f"
                        border.width: 1
                        border.color: "#3a7460"
                        Text {
                            id: tooltipText
                            anchors.centerIn: parent
                            width: tooltipMetrics.width
                            text: "Workspace " + workspaceButton.modelData.name
                            color: "#d7e9df"
                            wrapMode: Text.NoWrap
                            textFormat: Text.PlainText
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 11
                            maximumLineCount: 1
                            elide: Text.ElideNone
                        }
                    }
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: workspaceButton.modelData.active ? 12 : 7
                    height: width
                    radius: width / 2
                    color: workspaceButton.modelData.urgent ? "#ff6048" : mouse.containsMouse ? "#3dd1b0" : workspaceButton.modelData.active ? "transparent" : "#47665d"
                    border.width: workspaceButton.modelData.active ? 2 : 0
                    border.color: "#3dd1b0"
                    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                }
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: tooltipDelay.restart()
                    onExited: { tooltipDelay.stop(); workspaceButton.tooltipOpen = false; }
                    onClicked: {
                        tooltipDelay.stop();
                        workspaceButton.tooltipOpen = false;
                        root.activate(workspaceButton.modelData);
                    }
                    onWheel: event => {
                        tooltipDelay.stop();
                        workspaceButton.tooltipOpen = false;
                        if (event.angleDelta.y === 0) return;
                        let activeIndex = -1;
                        for (let index = 0; index < workspaceRepeater.count; ++index) {
                            const candidate = workspaceRepeater.itemAt(index);
                            if (candidate && candidate.visible && candidate.modelData.active) activeIndex = index;
                        }
                        for (let offset = 1; offset <= workspaceRepeater.count; ++offset) {
                            const index = (activeIndex + (event.angleDelta.y > 0 ? -offset : offset) + workspaceRepeater.count) % workspaceRepeater.count;
                            const candidate = workspaceRepeater.itemAt(index);
                            if (candidate && candidate.visible) { root.activate(candidate.modelData); break; }
                        }
                        event.accepted = true;
                    }
                }
            }
        }
    }
}
