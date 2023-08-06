import SwiftUI

@main
struct ParedesDeCouraCalendarApp: App {
    @StateObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .onAppear {
                    store.load()
                }
        }
    }
}
