import SwiftUI

@main
struct PythonFlashcardsApp: App {
    init() {
        CrashHandler.shared.install()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
