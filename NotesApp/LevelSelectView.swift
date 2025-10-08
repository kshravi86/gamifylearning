import SwiftUI

struct LevelSelectView: View {
    let levels = FlashcardsRepository.levels
    @State private var bests: [Int: Int] = [:]

    var body: some View {
        ZStack {
            WaterTheme.gradient(for: .light).ignoresSafeArea()
            List(levels, id: \.level) { deck in
                NavigationLink {`n                    FlashcardsGameView(deck: deck) { score in`n                        let best = max(ProgressStore.shared.best(for: deck.level), score)`n                        ProgressStore.shared.setBest(best, for: deck.level)`n                        reloadBests()`n                    }`n                label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Level \(deck.level): \(deck.title)")
                                .font(.headline)
                            Text(deck.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary\)`n                }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Best: \(bests[deck.level] ?? 0)/\(deck.cards.count)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            DifficultyPills(level: deck.level\)`n                }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(WaterTheme.softStroke(corner: 12))
                    \)`n                }
            }
            .scrollContentBackground(.hidden\)`n                }
        .navigationTitle("Choose Level")
        .onAppear { reloadBests() }
    }

    private func reloadBests() {
        var map: [Int: Int] = [:]
        for deck in levels {
            map[deck.level] = ProgressStore.shared.best(for: deck.level\)`n                }
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
                    .frame(width: 8, height: 8\)`n                }
        }
    }
    private var difficultyBand: Int { level <= 3 ? 1 : (level <= 7 ? 2 : 3) }
}

