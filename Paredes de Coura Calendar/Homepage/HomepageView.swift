import SwiftUI

struct HomepageView: View {
    
    @ObservedObject var viewModel: HomepageViewModel
    @State private var selectedDate: FestivalDate

    init(viewModel: HomepageViewModel) {
        self.viewModel = viewModel
        _selectedDate = State(initialValue: viewModel.dates[0])
    }

    private var dateSelectorView: some View {
        LazyHStack {
            ForEach(viewModel.dates) { festivalDate in
                Button(festivalDate.date.description) {
                    selectedDate = festivalDate
                    viewModel.filterConcerts(by: selectedDate)
                }
            }
        }
    }

    private var itemsListView: some View {
        ScrollView {
            if viewModel.filteredConcerts.isEmpty {
                Text("No concerts for this date")
            } else {
                LazyVStack {
                    ForEach(viewModel.filteredConcerts) {
                        ConcertView(viewModel: $0)
                    }
                }
            }
        }
    }

    var body: some View {
        VStack {
            // Header
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 8) {
                    ScrollView(.horizontal) {
                        dateSelectorView
                    }
                }
                .padding(.leading, 8)
                
                Text(selectedDate.date.description)
                    .padding(.leading, 4)
            }
            Divider()
            
            itemsListView
        }
    }
}

//struct HomepageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomepageView()
//    }
//}
