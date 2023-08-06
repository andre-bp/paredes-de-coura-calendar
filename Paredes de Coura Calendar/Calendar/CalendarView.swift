import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var selectedDate: Date
    @State private var selectedStage: Stage
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        _selectedDate = State(initialValue: viewModel.dates[0])
        _selectedStage = State(initialValue: viewModel.stages[0])
    }

    var body: some View {
        VStack {
            Text(title)
                .padding(.leading, 4)
                .padding(.bottom, 8)
                .font(Font.title)
                .bold()

            filtersView
                .padding(.leading, 8)
                .frame(height: 150)

            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredConcerts) { concert in
                        concertView(viewModel: concert)
                    }
                }
            }
        }
        .onAppear {
            viewModel.filterConcerts(date: selectedDate, stage: selectedStage)
        }
    }

    @ViewBuilder
    func concertView(viewModel: ConcertViewModel) -> some View {
        HStack(alignment: .top, spacing: 0) {
//            AsyncImage(url: viewModel.imageURL)
            Image(systemName: "music.mic")
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.concertHour)

                Text(viewModel.artist)

                Text(viewModel.stageName)
            }

            Spacer()

            Image(systemName: bookmarkIconSystemName(isBookmarked: viewModel.isBookmarked))
                .onTapGesture {
                    viewModel.isBookmarked.toggle()
                    withAnimation {
                        self.viewModel.filterConcerts(date: selectedDate, stage: selectedStage)
                    }
                }
        }
    }

    @ViewBuilder
    var filtersView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.dates, id: \.self) { day in
                        Button(day.weekday()) {
                            selectedDate = day
                            viewModel.filterConcerts(date: day, stage: selectedStage)
                        }
                        .buttonStyle(RoundedButtonStyle(isSelected: selectedDate == day))
                    }
                }
            }

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.stages) { stage in
                        Button(stage.name) {
                            selectedStage = stage
                            viewModel.filterConcerts(date: selectedDate, stage: stage)
                        }
                        .buttonStyle(RoundedButtonStyle(isSelected: selectedStage.id == stage.id))
                    }
                }
            }
        }
    }

    var title: String {
        switch viewModel.type {
        case .general:
            return "General Calendar"
        case .saved:
            return "My Calendar"
        }
    }

    private func bookmarkIconSystemName(isBookmarked: Bool) -> String {
        if isBookmarked {
            return "bookmark.fill"
        } else {
            return "bookmark"
        }
    }
}

//#if targetEnvironment(simulator)
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
//#endif
