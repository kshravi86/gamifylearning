import SwiftUI

struct FlashcardsGameView: View {
    let deck: FlashcardDeck
    var onFinish: ((Int) -> Void)? = nil

    @State private var index: Int = 0
    @State private var order: [Int] = []
    @State private var correct: Int = 0
    @State private var finished: Bool = false
    @State private var options: [String] = []
    @State private var correctOption: String = ""
    @State private var selectedIndex: Int? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                header
                card
                controls
                progress
            }
            .padding()
        }
        .navigationTitle("Level \(deck.level)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if order.isEmpty { start(resetScore: false) } }
        .sheet(isPresented: $finished) {
            ResultSheet(score: correct, total: deck.cards.count, onClose: { finished = false }) {
                start(resetScore: true)
                finished = false
            }
        }
    }

    private var header: some View {
        HStack {
            Text(deck.title)
                .font(.headline)
            Spacer()
            Text("\(min(index + 1, deck.cards.count))/\(deck.cards.count)")
                .foregroundStyle(.secondary)
        }
    }

    private var card: some View {
        ZStack {
            if let c = safeCurrent {
                quizCard(for: c)
                    .id(order[index])
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                VStack(spacing: 12) {
                    ProgressView("Preparing cards…")
                    Text("Level \(deck.level): \(deck.title)")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 220)
                .padding()
                .background(WaterTheme.cardBackground())
                .overlay(WaterTheme.softStroke())
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: index)
    }

    private func quizCard(for c: Flashcard) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(c.prompt)
                .font(.title3.weight(.semibold))
            if let hint = c.hint, selectedIndex == nil {
                Text("Hint: \(hint)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Divider()
            VStack(spacing: 10) {
                ForEach(Array(options.enumerated()), id: \.0) { (i, opt) in
                    Button(action: { choose(i) }) {
                        HStack {
                            Text(opt)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(foregroundColor(for: i))
                            Spacer()
                            if selectedIndex != nil {
                                Image(systemName: iconName(for: i))
                                    .foregroundColor(foregroundColor(for: i))
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(backgroundColor(for: i))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                    }
                    .disabled(selectedIndex != nil)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(WaterTheme.cardBackground())
        .overlay(WaterTheme.softStroke())
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Spacer()
            Button {
                proceed()
            } label: {
                Text(index + 1 >= deck.cards.count ? "Finish" : (selectedIndex == nil ? "Skip" : "Next"))
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top, 4)
    }

    private var progress: some View {
        VStack(alignment: .leading, spacing: 6) {
            ProgressView(value: Double(min(index, deck.cards.count)), total: Double(deck.cards.count))
            HStack {
                Text("Correct: \(correct)")
                Spacer()
                Text("Remaining: \(deck.cards.count - index)")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }

    private var safeCurrent: Flashcard? {
        guard !order.isEmpty, index >= 0, index < order.count, order[index] < deck.cards.count else { return nil }
        return deck.cards[order[index]]
    }

    private func start(resetScore: Bool = false) {
        order = Array(deck.cards.indices).shuffled()
        index = 0
        if resetScore { correct = 0 }
        buildRound()
    }

    private func proceed() {
        if index + 1 >= deck.cards.count {
            onFinish?(correct)
            finished = true
        } else {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                index += 1
            }
            buildRound()
        }
    }

    private func choose(_ i: Int) {
        guard selectedIndex == nil else { return }
        selectedIndex = i
        if options.indices.contains(i) && options[i] == correctOption {
            correct += 1
        }
    }

    private func buildRound() {
        selectedIndex = nil
        guard let c = safeCurrent else { options = []; correctOption = ""; return }
        let correctAns = c.answer
        var distractors = deck.cards.map { $0.answer }.filter { $0 != correctAns }
        distractors.shuffle()
        if distractors.count < 3 {
            let fillers = ["pass", "None", "True", "False", "print(x)", "len(s)"]
            for f in fillers where distractors.count < 3 && f != correctAns {
                distractors.append(f)
            }
        }
        let picks = Array(distractors.prefix(3))
        var opts = [correctAns] + picks
        opts.shuffle()
        options = opts
        correctOption = correctAns
    }

    private func backgroundColor(for i: Int) -> Color {
        guard let sel = selectedIndex else { return Color(.secondarySystemFill) }
        let isCorrect = options[i] == correctOption
        if isCorrect { return Color.green.opacity(0.18) }
        if sel == i { return Color.red.opacity(0.18) }
        return Color(.secondarySystemFill)
    }

    private func foregroundColor(for i: Int) -> Color {
        guard let sel = selectedIndex else { return Color.primary }
        let isCorrect = options[i] == correctOption
        if isCorrect { return .green }
        if sel == i { return .red }
        return .primary
    }

    private func iconName(for i: Int) -> String {
        let isCorrect = options[i] == correctOption
        return isCorrect ? "checkmark.circle.fill" : "xmark.circle"
    }
}

private struct ResultSheet: View {
    let score: Int
    let total: Int
    var onClose: () -> Void
    var onRetry: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: score == total ? "checkmark.seal.fill" : "graduationcap.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(score == total ? .green : .blue)
                Text("Level Complete")
                    .font(.title2.bold())
                Text("You got \(score) out of \(total) correct.")
                    .foregroundStyle(.secondary)
                HStack {
                    Button(role: .cancel) { onClose() } label: { Text("Done") }
                    Button(action: onRetry) { Text("Retry Level") }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.top, 8)
                Spacer()
            }
            .padding()
            .navigationTitle("Results")
        }
    }
}
