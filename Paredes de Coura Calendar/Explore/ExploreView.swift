import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var store: Store
    @ObservedObject var viewModel: ExploreViewModel
    @State var searchBarInput: String = "Search an artist here"

    var body: some View {
        VStack {

            headerView

            Divider()
                .padding(.bottom)

            resultsView
        }
        .padding(.horizontal, 20)
    }

    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Search")
                    .bold()
                    .font(.title)
                    .padding(.bottom, 8)

                SearchBar(
                    text: $searchBarInput,
                    submitClosure: { input in
                        viewModel.filterArtist(input)
                    }
                )
                .onChange(of: searchBarInput, perform: { input in
                    viewModel.filterArtist(input)
                })

            }
            Spacer()
        }
        .padding(.horizontal, 12)
    }

    var resultsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.concertsByDay.values.isEmpty {
                EmptyView()
            } else {
                ForEach(Array(viewModel.concertsByDay.keys.sorted(by: <)), id: \.self) { day in
                    if let concerts = viewModel.concertsByDay[day],
                       !concerts.isEmpty {
                        VStack(alignment: .center, spacing: 0) {
                            Text(day.weekday())
                                .bold()
                                .padding(.bottom, 4)
                            ForEach(concerts) { concert in
                                searchResultView(concert: concert)
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func searchResultView(concert: ConcertViewModel) ->  some View {
        HStack(alignment: .center, spacing: 0) {
            AsyncImage(url: concert.imageURL) { image in
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
                Text(concert.concertHour)
                    .padding(.bottom, 12)
                Text(concert.artist)
                    .padding(.bottom, 8)
                    .bold()

                HStack(alignment: .center, spacing: 0) {
                    Circle()
                        .fill(circleColor(isBookmarked: concert.isBookmarked, stage: concert.stageName))
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 8)
                    Text(concert.stageName)
                }
            }

            Spacer()

            Image(systemName: concert.isBookmarked.bookmarkIconSystemName)
                .onTapGesture {
                    concert.isBookmarked.toggle()
                    store.saveBookmark(id: concert.id, isBookmarked: concert.isBookmarked)
                    withAnimation {
                        viewModel.objectWillChange.send()
                    }
                }
                .padding(.top, 8)
                .padding()
        }
        .background(backgroundColor(isBookmarked: concert.isBookmarked, stage: concert.stageName))
        .contentShape(Rectangle())
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
}

//#if targetEnvironment(simulator)
//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView(viewModel: ExploreViewModel(concerts: [ConcertViewModel(.stub())], festivalDates: []))
//    }
//}
//#endif
