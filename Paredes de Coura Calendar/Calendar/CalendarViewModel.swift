import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    enum CalendarType {
        case general, saved
    }

    let concerts: [ConcertViewModel]
    let dates: [Date]
    @Published var filteredConcerts: [ConcertViewModel] = []
    let stages: [Stage]
    let type: CalendarType

    init(concerts: [ConcertViewModel], dates: [Date], stages: [Stage], type: CalendarType) {
        self.concerts = concerts
        self.dates = dates
        self.stages = stages
        self.type = type
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
