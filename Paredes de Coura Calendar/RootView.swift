import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        switch store.state {
        case .failed, .initial:
            EmptyView()
        case .loading:
            ProgressView()
        case .loaded:
            TabView {
                Group {
                    HomepageView(viewModel: HomepageViewModel(concerts: store.concerts))
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }

                    ExploreView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Explore")
                        }

                    CalendarView(viewModel: CalendarViewModel(concerts: store.concerts, dates: store.festivalDates, stages: store.stages, type: .general))
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }

                    CalendarView(viewModel: CalendarViewModel(concerts: store.concerts, dates: store.festivalDates, stages: store.stages, type: .saved))
                        .tabItem {
                            Image(systemName: "bookmark")
                            Text("Saved")
                        }
                }
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
            
        }
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
