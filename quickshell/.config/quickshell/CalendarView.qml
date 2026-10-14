import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    // Months use JavaScript's zero-based convention (January = 0).
    property int displayedYear: new Date().getFullYear()
    property int displayedMonth: new Date().getMonth()
    readonly property date today: clockState.today
    readonly property date monthStart: new Date(displayedYear, displayedMonth, 1)
    readonly property int leadingDays: (monthStart.getDay() + 6) % 7

    implicitWidth: 334
    implicitHeight: content.implicitHeight + 32
    radius: 18
    color: "#040e0d"
    border.color: "#203b35"
    border.width: 1

    function showToday() {
        clockState.today = new Date();
        displayedYear = today.getFullYear();
        displayedMonth = today.getMonth();
    }

    function shiftMonth(offset) {
        const target = new Date(displayedYear, displayedMonth + offset, 1);
        displayedYear = target.getFullYear();
        displayedMonth = target.getMonth();
    }

    QtObject {
        id: clockState
        property date today: new Date()
    }

    // Keep today's marker fresh across midnight, including after suspend.
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            const now = new Date();
            if (now.toDateString() !== root.today.toDateString())
                clockState.today = now;
        }
    }

    component CalendarButton: Rectangle {
        id: button
        property string label: ""
        property string accessibleLabel: label
        signal clicked()

        implicitWidth: 30
        implicitHeight: 30
        radius: 8
        color: pointer.pressed ? "#24594b" : pointer.containsMouse ? "#173b31" : "#0b211c"
        border.width: activeFocus ? 1 : 0
        border.color: "#3dd1b0"
        activeFocusOnTab: true
        Accessible.role: Accessible.Button
        Accessible.name: accessibleLabel
        Accessible.onPressAction: clicked()
        Keys.onReturnPressed: clicked()
        Keys.onEnterPressed: clicked()
        Keys.onSpacePressed: clicked()

        Text {
            anchors.centerIn: parent
            text: button.label
            color: "#3dd1b0"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 14
        }

        MouseArea {
            id: pointer
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }

    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                Layout.fillWidth: true
                text: Qt.formatDate(root.monthStart, "MMMM yyyy")
                color: "#f5e2c5"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 17
                font.bold: true
                elide: Text.ElideRight
            }

            CalendarButton {
                label: "‹"
                accessibleLabel: "Previous month"
                onClicked: root.shiftMonth(-1)
            }

            CalendarButton {
                label: "›"
                accessibleLabel: "Next month"
                onClicked: root.shiftMonth(1)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: "#203b35"
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                delegate: Text {
                    required property string modelData
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 18
                    text: modelData
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#8aa89b"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 11
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 7
            rowSpacing: 4
            columnSpacing: 4

            Repeater {
                model: 42
                delegate: Rectangle {
                    id: dayCell
                    required property int index
                    readonly property date date: new Date(root.displayedYear, root.displayedMonth,
                                                         1 - root.leadingDays + index)
                    readonly property bool inMonth: date.getMonth() === root.displayedMonth
                    readonly property bool isToday: date.toDateString() === root.today.toDateString()

                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 32
                    radius: 8
                    color: isToday ? "#3dd1b0" : "transparent"
                    Accessible.role: Accessible.StaticText
                    Accessible.name: Qt.formatDate(date, "dddd, MMMM d, yyyy") + (isToday ? ", today" : "")

                    Text {
                        anchors.centerIn: parent
                        text: dayCell.date.getDate()
                        color: dayCell.isToday ? "#040e0d" : dayCell.inMonth ? "#f5e2c5" : "#526d60"
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 13
                        font.bold: dayCell.isToday
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            CalendarButton {
                implicitWidth: 66
                implicitHeight: 28
                label: "Today"
                accessibleLabel: "Go to the current month"
                onClicked: root.showToday()
            }

            Text {
                Layout.fillWidth: true
                text: Qt.formatDate(root.today, "ddd, d MMM yyyy")
                horizontalAlignment: Text.AlignRight
                color: "#8aa89b"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 10
                elide: Text.ElideRight
            }
        }
    }
}
