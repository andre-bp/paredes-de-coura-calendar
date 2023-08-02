import Foundation

final class RootViewModel: ObservableObject {
    enum AppState {
        case initial
        case loading
        case loaded
        case failed
    }

    lazy var festivalDates: [Date] = [
        Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 16)) ?? Date(),
        Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 17)) ?? Date(),
        Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 18)) ?? Date(),
        Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 19)) ?? Date()
    ]
    lazy var stages = [Stage(id: "1", name: "Vodafone"), Stage(id: "2", name: "Yorn")]

    var state: AppState
    @Published var concerts: [ConcertViewModel]

    init() {
        state = .initial
        concerts = []
    }

    func load() {
        state = .loading

        concerts = JSONParser.shared.parse(filename: "concerts").map { ConcertViewModel($0) }
        if concerts.isEmpty {
            state = .failed
        } else {
            state = .loaded
        }
    }
}
