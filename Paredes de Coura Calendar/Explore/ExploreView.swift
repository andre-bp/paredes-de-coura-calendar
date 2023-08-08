import SwiftUI

struct ExploreView: View {
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
                    .padding(.bottom, 8)

                SearchBar(
                    text: $searchBarInput,
                    submitClosure: { input in
                        withAnimation {
                            viewModel.filterArtist(input)
                        }
                    }
                )
                .onChange(of: searchBarInput, perform: { input in
                    withAnimation {
                        viewModel.filterArtist(input)
                    }
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
                        Text(day.weekday())
                        ForEach(concerts) { concert in
                            searchResultView(concert: concert)
                        }
                    }
                }
            }
        }
    }

    private func searchResultView(concert: ConcertViewModel) ->  some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "music.mic")
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(concert.concertHour)
                
                Text(concert.artist)
                
                Text(concert.stageName)
            }

            Spacer()

            Image(systemName: concert.isBookmarked.bookmarkIconSystemName)
                .onTapGesture {
                    concert.isBookmarked.toggle()
                    withAnimation {
                        viewModel.objectWillChange.send()
                    }
                }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView(viewModel: ExploreViewModel(concerts: [ConcertViewModel(.stub())], festivalDates: []))
    }
}
