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
                Button(festivalDate.date.weekday()) {
                    selectedDate = festivalDate
                    viewModel.filterConcerts(by: selectedDate)
                }
                .buttonStyle(RoundedButtonStyle(isSelected: selectedDate.id == festivalDate.id))
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
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    dateSelectorView
                }
                .padding(.leading, 8)
                .padding(.bottom, 4)
                .frame(height: 100)

                Text(selectedDate.date.formattedDateString())
                    .padding(.leading, 4)
                    .padding(.bottom, 8)
                    .font(Font.title)
                    .bold()
            }
            Spacer()

            Divider()
                .padding(.bottom)

            itemsListView
                .padding(.top, 4)
        }
    }
}

#if targetEnvironment(simulator)
struct HomepageView_Previews: PreviewProvider {
    static let festivalDates = [FestivalDate(id: "1", date: Date()), FestivalDate(id: "2", date: Date())]
    
    static let viewModel = HomepageViewModel(dates: festivalDates, concerts: [.stub()])
    
    static var previews: some View {
        HomepageView(viewModel: viewModel)
    }
}
#endif
