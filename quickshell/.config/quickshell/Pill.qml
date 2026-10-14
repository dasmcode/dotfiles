import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    property string icon: ""
    property string label: ""
    property color iconColor: "#3dd1b0"
    property int maxLabelWidth: 400
    property string tooltip: ""
    property bool active: false
    property bool tooltipOpen: false
    signal clicked()
    signal rightClicked()
    signal middleClicked()
    signal scrolled(real delta)

    implicitWidth: row.implicitWidth + 22
    implicitHeight: 33
    radius: height / 2
    color: mouse.containsMouse || active ? "#132a25" : "#040e0d"
    border.width: active ? 1 : 0
    border.color: "#3dd1b0"
    opacity: enabled ? 1 : 0.4
    Behavior on color { ColorAnimation { duration: 120 } }

    Timer {
        id: tooltipDelay
        interval: 550
        onTriggered: root.tooltipOpen = root.tooltip !== ""
    }

    TextMetrics {
        id: tooltipMetrics
        font: tooltipText.font
        text: root.tooltip
    }

    // A non-focusable, styled tooltip sits below the pill, never on the pointer.
    PopupWindow {
        id: tooltipPopup
        visible: root.tooltipOpen
        anchor.item: root
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
                text: root.tooltip
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

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onEntered: { if (root.tooltip !== "") tooltipDelay.restart(); }
        onExited: { tooltipDelay.stop(); root.tooltipOpen = false; }
        onClicked: event => {
            tooltipDelay.stop();
            root.tooltipOpen = false;
            if (event.button === Qt.RightButton) root.rightClicked();
            else if (event.button === Qt.MiddleButton) root.middleClicked();
            else root.clicked();
        }
        onWheel: event => {
            tooltipDelay.stop();
            root.tooltipOpen = false;
            if (event.angleDelta.y !== 0) root.scrolled(event.angleDelta.y);
            event.accepted = true;
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 7

        Text {
            text: root.icon
            color: root.iconColor
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 16
        }
        Text {
            text: root.label
            textFormat: Text.PlainText
            color: "#f5e2c5"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 16
            elide: Text.ElideRight
            Layout.maximumWidth: root.maxLabelWidth
            visible: root.label !== ""
        }
    }
}
