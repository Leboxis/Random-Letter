import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RouletteView()
                .tabItem {
                    Label("Roulette", systemImage: "arrow.triangle.2.circlepath")
                }
            LettersView()
                .tabItem {
                    Label("Lettres", systemImage: "textformat.abc")
                }
            AboutView()
                .tabItem {
                    Label("À propos", systemImage: "info.circle")
                }
        }
        .tint(Color(red: 0.45, green: 0.38, blue: 0.9))
    }
}

#Preview {
    ContentView()
        .environment(GameViewModel())
}
