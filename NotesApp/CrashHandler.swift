import Foundation
import Darwin

final class CrashHandler {
    static let shared = CrashHandler()
    private var installed = false

    private init() {}

    func install() {
        guard !installed else { return }
        installed = true

        NSSetUncaughtExceptionHandler { exception in
            ErrorLogger.shared.log(exception: exception)
        }

        let signals: [Int32] = [SIGABRT, SIGILL, SIGSEGV, SIGFPE, SIGBUS, SIGPIPE]
        for sig in signals {
            signal(sig) { s in
                // Minimal, async-signal-unsafe work avoided; delegate to logger and exit
                ErrorLogger.shared.log(signal: s)
                _Exit(s)
            }
        }
    }
}

