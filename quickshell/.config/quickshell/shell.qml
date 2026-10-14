import Quickshell

ShellRoot {
    ShellState { id: sharedState }

    // Variants follows output hot-plugging and gives each output its own bar.
    Variants {
        model: Quickshell.screens
        Bar {
            required property var modelData
            screen: modelData
            shellState: sharedState
        }
    }
}
