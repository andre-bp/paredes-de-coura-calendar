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
    @Published var sortRule: SortRule

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
        sortConcerts()
    }

    func sortConcerts() {
        switch sortRule {
        case .artistName:
            filteredConcerts.sort { $0.artist < $1.artist }
        case .date:
            filteredConcerts.sort { concertsSort(firstConcert: $0.date, secondConcert: $1.date) }
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

    func concertsSort(firstConcert: Date, secondConcert: Date) -> Bool {
        // The idea is to compare if a concert is scheduled before the start hour.
        // Even though a concert takes place at 1AM on 21st of May, it's still advertised as concert on 20th of May.
        // So this helper sorts the concerts in order to not have the ones before 16h at the start of the list.
        let startHour = 16

        let firstBeforeStart = firstConcert.hour < startHour
        let secondBeforeStart = secondConcert.hour < startHour

        switch (firstBeforeStart, secondBeforeStart) {
        case (true, false):
            return false
        case (false, true):
            return true
        default:
            return firstConcert < secondConcert
        }
    }
}
