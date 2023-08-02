import SwiftUI

struct ContentView: View {
    var viewModel: RootViewModel
    
    var body: some View {
        TabView {
            HomepageView(viewModel: viewModel.homepageViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            SavedView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
