import SwiftUI

@main
struct ParedesDeCouraCalendarApp: App {
    @StateObject var rootViewModel = RootViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootViewModel)
                .onAppear {
                    rootViewModel.load()
                }
        }
    }
}
