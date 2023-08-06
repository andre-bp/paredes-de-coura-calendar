import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    enum CalendarType {
        case general, saved

        var viewTitle: String {
            switch self {
            case .general:
                return "General Calendar"
            case .saved:
                return "My Calendar"
            }
        }
    }

    enum SortRule {
        case date, artistName
    }

    let concerts: [ConcertViewModel]
    let dates: [Date]
    @Published var filteredConcerts: [ConcertViewModel] = []
    let stages: [Stage]
    let type: CalendarType
    var sortRule: SortRule

    init(concerts: [ConcertViewModel], dates: [Date], stages: [Stage], type: CalendarType) {
        self.concerts = concerts
        self.dates = dates
        self.stages = stages
        self.type = type
        sortRule = .date
    }

    func filterConcerts(date: Date, stage: Stage?) {
        filteredConcerts = concerts.filter {
            switch type {
            case .general:
                return dateRule(concertDate: $0.date, selectedDate: date) && stageRule(concertStageName: $0.stageName, selectedStage: stage)
            case .saved:
                return $0.isBookmarked && dateRule(concertDate: $0.date, selectedDate: date) && stageRule(concertStageName: $0.stageName, selectedStage: stage)
            }
        }
    }

    func sortBy(rule: SortRule) {
        switch rule {
        case .artistName:
            filteredConcerts.sort { $0.artist < $1.artist }
        case .date:
            filteredConcerts.sort { $0.date < $1.date }
        }
    }

    private func stageRule(concertStageName: String, selectedStage: Stage?) -> Bool {
        guard let selectedStage else { return true }
        return concertStageName == selectedStage.name
    }

    private func dateRule(concertDate: Date, selectedDate: Date) -> Bool {
        let selectedDateComponents = selectedDate.dayMonthYearComponents()
        let concertDateComponents = concertDate.dayMonthYearComponents()
        return selectedDateComponents == concertDateComponents
    }
}
