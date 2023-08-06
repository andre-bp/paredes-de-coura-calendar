import Combine
import Foundation

final class ExploreViewModel: ObservableObject {
    let concerts: [ConcertViewModel]
    @Published var dict: [Date: [ConcertViewModel]] = [:]
    let festivalDates: [Date]

    init(concerts: [ConcertViewModel], festivalDates: [Date]) {
        self.concerts = concerts
        self.festivalDates = festivalDates
        festivalDates.forEach {
            dict[$0] = []
        }
    }

    func filterArtist(_ input: String) {
        if input.isEmpty {
            festivalDates.forEach {
                dict.removeValue(forKey: $0)
            }
        } else {
            festivalDates.forEach { date in
                dict[date] = concerts.filter { $0.date.dayMonthYearComponents() == date.dayMonthYearComponents() && $0.artist.hasPrefix(input) }.sorted(by: { $0.date < $1.date })
            }
        }
    }
}
