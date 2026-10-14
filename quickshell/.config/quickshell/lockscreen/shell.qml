import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam

ShellRoot {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    property string password: ""
    property bool failed: false
    readonly property string greeting: clock.date.getHours() < 12 ? "GOOD MORNING" : clock.date.getHours() < 18 ? "GOOD AFTERNOON" : "GOOD EVENING"
    // DP-2 is the primary output in ~/.config/hypr/modules/monitors.lua.
    readonly property string primaryMonitorName: "DP-2"

    function submitPassword() {
        if (password.length === 0 || pam.active)
            return;
        failed = false;
        pam.start();
    }

    PamContext {
        id: pam
        config: "login"

        onPamMessage: {
            if (responseRequired)
                respond(root.password);
        }

        onCompleted: result => {
            root.password = "";
            if (result === PamResult.Success) {
                lock.locked = false;
                Qt.quit();
            } else {
                root.failed = true;
            }
        }

        onError: error => {
            root.password = "";
            root.failed = true;
            console.warn("Lockscreen PAM error:", PamError.toString(error));
        }
    }

    WlSessionLock {
        id: lock
        locked: true

        WlSessionLockSurface {
            id: lockSurface
            color: "#0b1112"

            Rectangle {
                id: canvas
                anchors.fill: parent
                color: "#0b1112"
                clip: true
                readonly property bool compact: width < 1200
                readonly property bool isPrimaryMonitor: lockSurface.screen && lockSurface.screen.name === root.primaryMonitorName

                // Keep a real session-lock surface on every output. The secondary display only
                // shows this frozen, blurred capture; if capture fails, the opaque gradient below remains.
                ScreencopyView {
                    id: screenCapture
                    anchors.fill: parent
                    captureSource: lockSurface.screen
                    live: false
                    paintCursor: false
                    // Keep the raw frame off-screen; MultiEffect is the only visible copy.
                    visible: false
                    Component.onCompleted: {
                        if (!canvas.isPrimaryMonitor)
                            Qt.callLater(() => captureFrame());
                    }
                }
                MultiEffect {
                    anchors.fill: parent
                    source: screenCapture
                    visible: !canvas.isPrimaryMonitor && screenCapture.hasContent
                    autoPaddingEnabled: false
                    blurEnabled: true
                    blur: 1.0
                    blurMax: 64
                    brightness: -0.28
                    saturation: 0.45
                }

                // A quiet, abstract night-sky backdrop that works without an external wallpaper.
                Rectangle {
                    visible: canvas.isPrimaryMonitor || !screenCapture.hasContent
                    width: Math.max(canvas.width, canvas.height) * 1.12
                    height: width
                    radius: width / 2
                    x: canvas.width * 0.42
                    y: -height * 0.46
                    opacity: 0.42
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#294c42" }
                        GradientStop { position: 0.48; color: "#172b29" }
                        GradientStop { position: 1.0; color: "#0b1112" }
                    }
                }
                Rectangle {
                    visible: canvas.isPrimaryMonitor || !screenCapture.hasContent
                    width: Math.max(canvas.width, canvas.height) * 0.8
                    height: width
                    radius: width / 2
                    x: -width * 0.55
                    y: canvas.height * 0.55
                    opacity: 0.24
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#b18f60" }
                        GradientStop { position: 0.52; color: "#493d2f" }
                        GradientStop { position: 1.0; color: "#0b1112" }
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    visible: canvas.isPrimaryMonitor || !screenCapture.hasContent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#cc0b1112" }
                        GradientStop { position: 0.48; color: "#550b1112" }
                        GradientStop { position: 1.0; color: "#e60b1112" }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    visible: !canvas.isPrimaryMonitor && screenCapture.hasContent
                    color: "#660b1112"
                }

                // Fine frame lines give the background depth without competing with the clock.
                Rectangle {
                    visible: canvas.isPrimaryMonitor
                    x: canvas.width * 0.065
                    y: canvas.height * 0.09
                    width: canvas.width * 0.87
                    height: 1
                    color: "#24d6e4d5"
                }
                Rectangle {
                    visible: canvas.isPrimaryMonitor
                    x: canvas.width * 0.065
                    y: canvas.height * 0.91
                    width: canvas.width * 0.87
                    height: 1
                    color: "#24d6e4d5"
                }

                Text {
                    visible: canvas.isPrimaryMonitor
                    x: canvas.width * 0.065
                    y: canvas.height * 0.045
                    text: "M E L I   /   PRIVATE SESSION"
                    color: "#9aaea5"
                    font.family: "Montserrat"
                    font.pixelSize: 11
                    font.letterSpacing: 2.2
                }
                Text {
                    visible: canvas.isPrimaryMonitor
                    anchors.right: parent.right
                    anchors.rightMargin: canvas.width * 0.065
                    y: canvas.height * 0.045
                    text: lock.secure ? "●  SESSION SECURED" : "●  SECURING SESSION"
                    color: lock.secure ? "#a8d7b3" : "#d7bf8f"
                    font.family: "Montserrat"
                    font.pixelSize: 10
                    font.letterSpacing: 1.4
                }

                Item {
                    id: hero
                    visible: canvas.isPrimaryMonitor && !canvas.compact
                    x: canvas.width * 0.105
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.min(canvas.width * 0.46, 700)
                    height: 340

                    Text {
                        text: root.greeting
                        color: "#b6cbbf"
                        font.family: "Montserrat"
                        font.pixelSize: 13
                        font.letterSpacing: 4
                    }
                    Text {
                        y: 33
                        text: Qt.formatDateTime(clock.date, "HH:mm")
                        color: "#f2f1e9"
                        font.family: "Montserrat"
                        font.weight: Font.Light
                        font.pixelSize: Math.min(142, hero.width * 0.235)
                        font.letterSpacing: -5
                    }
                    Rectangle {
                        y: 205
                        width: 46
                        height: 2
                        color: "#c6aa78"
                    }
                    Text {
                        y: 227
                        text: Qt.formatDateTime(clock.date, "dddd, d MMMM yyyy")
                        color: "#bac6bc"
                        font.family: "Montserrat"
                        font.pixelSize: 17
                        font.letterSpacing: 0.6
                    }
                    Text {
                        y: 275
                        text: "Take a moment. Your workspace is waiting."
                        color: "#81918a"
                        font.family: "Montserrat"
                        font.pixelSize: 13
                        font.letterSpacing: 0.4
                    }
                }

                // On smaller displays, retain a strong clock above the centered unlock card.
                Column {
                    visible: canvas.isPrimaryMonitor && canvas.compact && canvas.height >= 620
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: canvas.height * 0.15
                    spacing: 8
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.formatDateTime(clock.date, "HH:mm")
                        color: "#f2f1e9"
                        font.family: "Montserrat"
                        font.weight: Font.Light
                        font.pixelSize: Math.min(86, canvas.width * 0.19)
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.formatDateTime(clock.date, "dddd, d MMMM")
                        color: "#b6c6bb"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        font.letterSpacing: 0.5
                    }
                }

                Rectangle {
                    id: authCard
                    visible: canvas.isPrimaryMonitor
                    width: Math.min(410, canvas.width - 40)
                    height: canvas.compact && canvas.height < 700 ? 380 : 430
                    x: canvas.compact ? (canvas.width - width) / 2 : canvas.width - width - canvas.width * 0.08
                    y: canvas.compact ? (canvas.height < 620 ? (canvas.height - height) / 2 : Math.max(canvas.height * 0.36, canvas.height - height - 34)) : (canvas.height - height) / 2
                    radius: 26
                    color: "#d90e1717"
                    border.width: 1
                    border.color: "#38c7d7c7"

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: 25
                        color: "transparent"
                        border.width: 1
                        border.color: "#12ffffff"
                    }

                    Column {
                        anchors.fill: parent
                        anchors.leftMargin: 38
                        anchors.rightMargin: 38
                        anchors.topMargin: 34
                        anchors.bottomMargin: 30
                        spacing: 0

                        Rectangle {
                            width: 48
                            height: 48
                            radius: 24
                            color: "#233c35"
                            border.width: 1
                            border.color: "#527265"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                anchors.centerIn: parent
                                text: "M"
                                color: "#d7c79f"
                                font.family: "Montserrat"
                                font.pixelSize: 21
                                font.weight: Font.Medium
                            }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            topPadding: 21
                            text: "Welcome back"
                            color: "#f0f1e9"
                            font.family: "Montserrat"
                            font.pixelSize: 23
                            font.weight: Font.Medium
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            topPadding: 7
                            text: "Meli  ·  unlock to continue"
                            color: "#91a39a"
                            font.family: "Montserrat"
                            font.pixelSize: 12
                            font.letterSpacing: 0.3
                        }

                        Item { width: 1; height: 27 }

                        Text {
                            text: "PASSWORD"
                            color: "#a6b8ad"
                            font.family: "Montserrat"
                            font.pixelSize: 10
                            font.letterSpacing: 1.8
                        }

                        Rectangle {
                            width: parent.width
                            height: 54
                            radius: 12
                            color: passwordInput.activeFocus ? "#1a302c" : "#111e1e"
                            border.width: 1
                            border.color: passwordInput.activeFocus ? "#8ba995" : "#345048"
                            clip: true

                            TextInput {
                                id: passwordInput
                                anchors.fill: parent
                                anchors.leftMargin: 17
                                anchors.rightMargin: 17
                                verticalAlignment: TextInput.AlignVCenter
                                color: "#edf1e9"
                                selectionColor: "#9dbda7"
                                selectedTextColor: "#0b1112"
                                font.family: "Montserrat"
                                font.pixelSize: 15
                                echoMode: TextInput.Password
                                passwordCharacter: "●"
                                passwordMaskDelay: 0
                                inputMethodHints: Qt.ImhSensitiveData
                                focus: canvas.isPrimaryMonitor
                                enabled: !pam.active
                                text: root.password
                                onTextEdited: {
                                    root.password = text;
                                    root.failed = false;
                                }
                                onAccepted: root.submitPassword()
                                Keys.onEscapePressed: {
                                    clear();
                                    root.password = "";
                                    root.failed = false;
                                }
                                Component.onCompleted: {
                                    if (canvas.isPrimaryMonitor)
                                        forceActiveFocus();
                                }
                            }
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 17
                                anchors.verticalCenter: parent.verticalCenter
                                visible: passwordInput.text.length === 0
                                text: "Enter your password"
                                color: "#6f8279"
                                font.family: "Montserrat"
                                font.pixelSize: 13
                            }
                            Text {
                                anchors.right: parent.right
                                anchors.rightMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                text: "↵"
                                color: "#82988c"
                                font.pixelSize: 17
                            }
                        }

                        Item { width: 1; height: 15 }

                        Rectangle {
                            width: parent.width
                            height: 52
                            radius: 12
                            color: pam.active ? "#29352f" : "#d8c69b"
                            opacity: passwordInput.text.length > 0 && !pam.active ? 1 : 0.72
                            Text {
                                anchors.centerIn: parent
                                text: pam.active ? "CHECKING…" : "UNLOCK"
                                color: "#17201c"
                                font.family: "Montserrat"
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                                font.letterSpacing: 2
                            }
                            MouseArea {
                                anchors.fill: parent
                                enabled: passwordInput.text.length > 0 && !pam.active
                                hoverEnabled: true
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: root.submitPassword()
                            }
                        }

                        Item { width: 1; height: 18 }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: pam.active ? "Verifying your credentials…" : root.failed ? "Password not accepted. Please try again." : "Press Enter to unlock"
                            color: root.failed ? "#e6a49a" : "#81938a"
                            font.family: "Montserrat"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                Text {
                    visible: canvas.isPrimaryMonitor && canvas.height >= 620
                    anchors.left: parent.left
                    anchors.leftMargin: canvas.width * 0.065
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: canvas.height * 0.045
                    text: "WAYLAND SESSION LOCK  /  " + Qt.formatDateTime(clock.date, "HH:mm:ss")
                    color: "#71847c"
                    font.family: "Montserrat"
                    font.pixelSize: 9
                    font.letterSpacing: 1.2
                }
                Text {
                    visible: canvas.isPrimaryMonitor && canvas.height >= 620
                    anchors.right: parent.right
                    anchors.rightMargin: canvas.width * 0.065
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: canvas.height * 0.045
                    text: "ESC  ·  CLEAR INPUT"
                    color: "#71847c"
                    font.family: "Montserrat"
                    font.pixelSize: 9
                    font.letterSpacing: 1.2
                }
            }
        }
    }
}
