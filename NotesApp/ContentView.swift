import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .learn
    @State private var learnPath = NavigationPath()

    var body: some View {
        TabView(selection: $selectedTab) {
            // Today (Hydration)
            NavigationStack {
                TodayView()
                    .navigationTitle("Hydration")
            }
            .tabItem { Label("Today", systemImage: "drop.fill") }
            .tag(Tab.today)

            // Learn (Flashcards)
            NavigationStack(path: $learnPath) {
                LevelSelectView()
                    .navigationTitle("Learn")
                    .navigationDestination(for: Int.self) { lvl in
                        if let deck = FlashcardsRepository.levels.first(where: { $0.level == lvl }) {
                            FlashcardsGameView(deck: deck) { score in
                                let best = max(ProgressStore.shared.best(for: deck.level), score)
                                ProgressStore.shared.setBest(best, for: deck.level)
                            }
                        }
                    }
                    .onAppear { applyLaunchNavigation() }
            }
            .tabItem { Label("Learn", systemImage: "graduationcap.fill") }
            .tag(Tab.learn)

            // History
            NavigationStack {
                HistoryView()
                    .navigationTitle("History")
            }
            .tabItem { Label("History", systemImage: "clock") }
            .tag(Tab.history)

            // Settings
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                ErrorLogView()
                                    .navigationTitle("Error Logs")
                            } label: { Image(systemName: "exclamationmark.triangle").accessibilityLabel("Error Logs") }
                        }
                    }
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
            .tag(Tab.settings)
        }
        .tint(WaterTheme.tint)
    }
}

private extension ContentView {
    enum Tab { case today, learn, history, settings }

    func applyLaunchNavigation() {
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "--auto-level"), i + 1 < args.count, let lvl = Int(args[i + 1]) {
            learnPath.append(lvl)
            selectedTab = .learn
        }
    }
}

#Preview { ContentView() }
