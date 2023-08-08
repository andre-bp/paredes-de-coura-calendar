import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var selectedDate: Date
    @State private var selectedStage: Stage?
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        _selectedDate = State(initialValue: viewModel.dates[0])
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.type.viewTitle)
                .padding(.leading, 4)
                .padding(.bottom, 8)
                .font(Font.title)
                .bold()

            filtersView
                .padding(.bottom, 12)
                .frame(height: 200)

            Divider()
                .padding(.bottom)

            concertsView
                .padding(.horizontal, 10)
        }
        .padding(.leading, 10)
        .onAppear {
            viewModel.filterConcerts(date: selectedDate, stage: selectedStage)
        }
    }

    private var concertsView: some View {
        ScrollView {
            if viewModel.filteredConcerts.isEmpty {
                
            } else {
                LazyVStack {
                    ForEach(viewModel.filteredConcerts) { concert in
                        concertView(viewModel: concert)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func concertView(viewModel: ConcertViewModel) -> some View {
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

            Image(systemName: viewModel.isBookmarked.bookmarkIconSystemName)
                .onTapGesture {
                    viewModel.isBookmarked.toggle()
                    withAnimation {
                        self.viewModel.filterConcerts(date: selectedDate, stage: selectedStage)
                    }
                }
        }
    }

    private var filtersView: some View {
        VStack(alignment: .leading, spacing: 0) {
            sortView
            datesView
            stagesView
        }
    }

    private var sortView: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("Sort by")
                .padding(.trailing, 2)
                .bold()

            Button("Date") {
                viewModel.sortRule = .date
                viewModel.sortConcerts()
            }
            .buttonStyle(RoundedButtonStyle(isSelected: viewModel.sortRule == .date))

            Button("Artist Name") {
                viewModel.sortRule = .artistName
                viewModel.sortConcerts()
            }
            .buttonStyle(RoundedButtonStyle(isSelected: viewModel.sortRule == .artistName))
        }
    }

    private var datesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
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
    }

    private var stagesView: some View {
        HStack {
            Button("All") {
                selectedStage = nil
                viewModel.filterConcerts(date: selectedDate, stage: nil)
            }
            .buttonStyle(RoundedButtonStyle(isSelected: selectedStage == nil ? true : false ))

            ForEach(viewModel.stages) { stage in
                Button(stage.name) {
                    selectedStage = stage
                    viewModel.filterConcerts(date: selectedDate, stage: stage)
                }
                .buttonStyle(RoundedButtonStyle(isSelected: selectedStage?.id == stage.id))
            }
        }
    }
}

extension Bool {
    var bookmarkIconSystemName: String {
        return self ? "bookmark.fill" : "bookmark"
    }
}

//#if targetEnvironment(simulator)
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
//#endif
