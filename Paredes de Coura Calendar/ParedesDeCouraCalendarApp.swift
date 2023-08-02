import SwiftUI

@main
struct ParedesDeCouraCalendarApp: App {
    let viewModel = RootViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
