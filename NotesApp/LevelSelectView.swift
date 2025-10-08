import SwiftUI

struct LevelSelectView: View {
    let levels = FlashcardsRepository.levels
    @State private var bests: [Int: Int] = [:]

    var body: some View {\n        ZStack {\n            WaterTheme.gradient(for: .light).ignoresSafeArea()\n            List(levels, id: \\.level) { deck in
            NavigationLink(value: deck.level) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Level \(deck.level): \(deck.title)")
                            .font(.headline)
                        Text(deck.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Best: \(bests[deck.level] ?? 0)/\(deck.cards.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        DifficultyPills(level: deck.level)
                    }
                }
                \.padding(.vertical, 10)\n                    .padding(.horizontal, 6)\n                    .background(\n                        RoundedRectangle(cornerRadius: 12, style: .continuous)\n                            .fill(.ultraThinMaterial)\n                            .overlay( WaterTheme.softStroke(corner: 12) )\n                    )
            }
        }
        \.scrollContentBackground(.hidden)\n        }\n        \.navigationTitle("Choose Level")
        .navigationDestination(for: Int.self) { lvl in
            if let deck = levels.first(where: { $0.level == lvl }) {
                FlashcardsGameView(deck: deck) { score in
                    let best = max(ProgressStore.shared.best(for: deck.level), score)
                    ProgressStore.shared.setBest(best, for: deck.level)
                    reloadBests()
                }
            }
        }
        .onAppear { reloadBests() }
    }

    private func reloadBests() {
        var map: [Int: Int] = [:]
        for deck in levels {
            map[deck.level] = ProgressStore.shared.best(for: deck.level)
        }
        bests = map
    }
}

private struct DifficultyPills: View {
    let level: Int
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...3, id: \.self) { i in
                Circle()
                    .fill(i <= difficultyBand ? Color.orange : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
    private var difficultyBand: Int { level <= 3 ? 1 : (level <= 7 ? 2 : 3) }
}

