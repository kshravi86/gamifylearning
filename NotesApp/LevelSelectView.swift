import SwiftUI

struct LevelSelectView: View {
    let levels = FlashcardsRepository.levels
    @State private var bests: [Int: Int] = [:]

    var body: some View {
        List(levels, id: \.level) { deck in
                NavigationLink(destination:
                    FlashcardsGameView(deck: deck) { score in
                        let best = max(ProgressStore.shared.best(for: deck.level), score)
                        ProgressStore.shared.setBest(best, for: deck.level)
                        reloadBests()
                    }
                ) {
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
                    .padding(.vertical, 4)
                }
        }
        .navigationTitle("Choose Level")
        .listStyle(.insetGrouped)
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
