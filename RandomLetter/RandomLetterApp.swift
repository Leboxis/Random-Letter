import SwiftUI

@main
struct RandomLetterApp: App {
    @State private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
