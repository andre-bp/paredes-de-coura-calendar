import Foundation

final class HomepageViewModel: ObservableObject {
    lazy var dates: [Date] = [Date(), Date().dayAfter]
    let concerts: [ConcertViewModel]
    @Published var filteredConcerts: [ConcertViewModel] = []

    init(concerts: [ConcertViewModel]) {
        self.concerts = concerts
        filterConcerts(by: dates[0])
    }

    func filterConcerts(by date: Date) {
        let selectedComponents = date.dayMonthYearComponents()

        filteredConcerts = concerts.filter {
            let itemcomponent = $0.date.dayMonthYearComponents()
            return itemcomponent == selectedComponents
        }
    }

    func buttonText(selectedDate: Date) -> String {
        for (index, date) in dates.enumerated() {
            if date == selectedDate {
                if index == 0 {
                    return "Today"
                } else if index == 1 {
                    return "Tomorrow"
                }
            }
        }
        return ""
    }
}
