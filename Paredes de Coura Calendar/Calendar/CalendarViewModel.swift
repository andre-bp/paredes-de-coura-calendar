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

    func filterConcerts(date: Date, stage: Stage) {
        let selectedComponents = date.dayMonthYearComponents()
        
        filteredConcerts = concerts.filter {
            let concertDateComponent = $0.date.dayMonthYearComponents()
            
            switch type {
            case .general:
                return concertDateComponent == selectedComponents && $0.stageName == stage.name
            case .saved:
                return $0.isBookmarked && concertDateComponent == selectedComponents && $0.stageName == stage.name
            }
        }
    }
}
