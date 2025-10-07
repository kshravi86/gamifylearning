import SwiftUI

struct FlashcardsGameView: View {
    let deck: FlashcardDeck
    var onFinish: ((Int) -> Void)? = nil

    @State private var index: Int = 0
    @State private var order: [Int] = []
    @State private var showAnswer: Bool = false
    @State private var correct: Int = 0
    @State private var finished: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            header
            card
            controls
            progress
        }
        .padding()
        .navigationTitle("Level \(deck.level)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if order.isEmpty { start(resetScore: false) }
        }
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
            Text("\(index + 1)/\(deck.cards.count)")
                .foregroundStyle(.secondary)
        }
    }

    private var card: some View {
        guard let c = safeCurrent else {
            return AnyView(
                VStack(spacing: 12) {
                    ProgressView("Preparing cards…")
                    Text("Level \(deck.level): \(deck.title)")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            )
        }
        return AnyView(
            VStack(alignment: .leading, spacing: 12) {
                Text(c.prompt)
                    .font(.title3.weight(.semibold))
                if let hint = c.hint, !showAnswer {
                    Text("Hint: \(hint)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Divider()
                if showAnswer {
                    ScrollView {
                        Text(c.answer)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .transition(.opacity)
                } else {
                    Text("Tap ‘Show Answer’ to reveal")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: 320)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        )
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button(action: { withAnimation { showAnswer.toggle() } }) {
                Label(showAnswer ? "Hide Answer" : "Show Answer", systemImage: showAnswer ? "eye.slash" : "eye")
            }
            .buttonStyle(.bordered)

            Spacer()

            Button(role: .destructive) { next(correct: false) } label: {
                Label("Need Review", systemImage: "xmark.circle")
            }
            .buttonStyle(.bordered)

            Button { next(correct: true) } label: {
                Label("I Got It", systemImage: "checkmark.circle.fill")
            }
            .buttonStyle(.borderedProminent)
        }
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
        showAnswer = false
        if resetScore { correct = 0 }
    }

    private func next(correct gotIt: Bool) {
        if gotIt { correct += 1 }
        if index + 1 >= deck.cards.count {
            onFinish?(correct)
            finished = true
        } else {
            index += 1
            showAnswer = false
        }
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
