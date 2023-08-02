import Foundation

final class HomepageViewModel: ObservableObject {
    let dates: [FestivalDate]
    let concerts: [ConcertViewModel]
    @Published var filteredConcerts: [ConcertViewModel] = []
    
    init(dates: [FestivalDate], concerts: [Concert]) {
        self.dates = dates
        self.concerts = concerts.map { ConcertViewModel($0) }
        filterConcerts(by: dates[0])
    }
    
    func filterConcerts(by date: FestivalDate) {
        let selectedComponents = date.date.dayMonthYearComponents()
        
        filteredConcerts = concerts.filter {
            let itemcomponent = $0.date.dayMonthYearComponents()
            return itemcomponent == selectedComponents
        }
    }
}

struct FestivalDate: Identifiable {
    let id: String
    let date: Date
}
