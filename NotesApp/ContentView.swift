import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
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
        }
    }
}

#Preview {
    ContentView()
}
