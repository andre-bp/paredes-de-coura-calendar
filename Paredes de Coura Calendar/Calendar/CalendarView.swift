import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var selectedDate: Date
    @State private var selectedStage: Stage?
    @EnvironmentObject var store: Store
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        _selectedDate = State(initialValue: viewModel.dates[0])
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.type.viewTitle)
                .bold()
                .font(Font.title)
                .padding(.leading, 12)
                .padding(.bottom, 8)

            filtersView
                .padding(.bottom, 12)
                .padding(.leading, 20)
                .frame(height: 200)
            
            Divider()

            concertsView
                .padding(.horizontal, -12)
        }
        .padding(.horizontal, 12)
        .onAppear {
            viewModel.filterConcerts(date: selectedDate, stage: selectedStage)
        }
    }

    private var concertsView: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.filteredConcerts.isEmpty {
                EmptyView()
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredConcerts) { concert in
                        concertView(viewModel: concert)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func concertView(viewModel: ConcertViewModel) -> some View {
        HStack(alignment: .center, spacing: 0) {
            AsyncImage(url: viewModel.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 100, height: 100)
            }
            .padding()

            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.concertHour)
                    .padding(.bottom, 12)
                Text(viewModel.artist)
                    .padding(.bottom, 8)
                    .bold()

                HStack(alignment: .center, spacing: 0) {
                    Circle()
                        .fill(circleColor(isBookmarked: viewModel.isBookmarked, stage: viewModel.stageName))
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 8)
                    Text(viewModel.stageName)
                }
            }

            Spacer()

            Image(systemName: bookmarkIcon(isBookmarked: viewModel.isBookmarked))
                .onTapGesture {
                    viewModel.isBookmarked.toggle()
                    store.saveBookmark(id: viewModel.id, isBookmarked: viewModel.isBookmarked)
                    withAnimation {
                        self.viewModel.filterConcerts(date: selectedDate, stage: selectedStage)
                    }
                }
                .padding(.top, 8)
                .padding()
        }
        .background(backgroundColor(isBookmarked: viewModel.isBookmarked, stage: viewModel.stageName))
        .contentShape(Rectangle())
    }

    private func backgroundColor(isBookmarked: Bool, stage: String) -> Color {
        switch isBookmarked {
        case true:
            if stage == "Vodafone" {
                return Color.red
            } else {
                return Color.purple
            }
        case false:
            if stage == "Vodafone" {
                return Color(red: 255 / 255, green: 202 / 255, blue: 202 / 255)
            } else {
                return Color(red: 232 / 255, green: 212 / 255, blue: 252 / 255)
            }
        }
    }

    private func circleColor(isBookmarked: Bool, stage: String) -> Color {
        if isBookmarked {
            return .white
        } else {
            if stage == "Vodafone" {
                return .red
            } else {
                return .purple
            }
        }
    }
    
    private var filtersView: some View {
        VStack(alignment: .leading, spacing: 4) {
            sortView
            datesView
            stagesView
        }
    }

    private var sortView: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("Sort by")
                .padding(.trailing, 4)
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
                .buttonStyle(RoundedButtonStyle(isSelected: selectedStage?.id == stage.id, stage: stage))
            }
        }
    }

    private func bookmarkIcon(isBookmarked: Bool) -> String {
        switch viewModel.type {
        case .general:
            return isBookmarked.bookmarkIconSystemName
        case .saved:
            return "trash.fill"
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
