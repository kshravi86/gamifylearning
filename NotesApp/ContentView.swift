import SwiftUI

struct ContentView: View {
    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navPath) {
            VStack(spacing: 20) {
                Text("Python Flashcards")
                    .font(.largeTitle.bold())
                Text("10 levels • increasing difficulty")
                    .foregroundStyle(.secondary)
                NavigationLink {
                    LevelSelectView()
                } label: {
                    Text("Start Learning")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Levels") {
                        LevelSelectView()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Logs") {
                        ErrorLogView()
                    }
                }
            }
            // Provide destination mapping for Int values triggered by nested links
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
    }
}

private extension ContentView {
    func applyLaunchNavigation() {
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "--auto-level"), i + 1 < args.count, let lvl = Int(args[i + 1]) {
            // push the level value to trigger navigationDestination
            navPath.append(lvl)
        }
    }
}

#Preview {
    ContentView()
}
