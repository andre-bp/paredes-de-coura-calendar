import Combine
import Foundation

final class ExploreViewModel: ObservableObject {
    let concerts: [ConcertViewModel]
    @Published var concertsByDay: [Date: [ConcertViewModel]] = [:]
    let festivalDates: [Date]

    init(concerts: [ConcertViewModel], festivalDates: [Date]) {
        self.concerts = concerts
        self.festivalDates = festivalDates
        festivalDates.forEach {
            concertsByDay[$0] = []
        }
    }

    func filterArtist(_ input: String) {
        if input.isEmpty {
            festivalDates.forEach {
                concertsByDay.removeValue(forKey: $0)
            }
        } else {
            festivalDates.forEach { date in
                concertsByDay[date] = concerts.filter {
                    return $0.date.dayMonthYearComponents() == date.dayMonthYearComponents()
                    && $0.artist.lowercased().hasPrefix(input.lowercased())
                }
            }
        }
    }
}
