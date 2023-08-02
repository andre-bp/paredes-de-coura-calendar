import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: RootViewModel

    var body: some View {
        switch viewModel.state {
        case .failed, .initial:
            EmptyView()
        case .loading:
            ProgressView()
        case .loaded:
            TabView {
                HomepageView(viewModel: HomepageViewModel(concerts: viewModel.concerts))
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
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
