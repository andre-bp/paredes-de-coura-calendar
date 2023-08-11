import CoreData
import Foundation

final class Store: ObservableObject {
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
    var coreDataConcerts: [ConcertCD]
    let container: NSPersistentContainer

    init() {
        state = .initial
        concerts = []
        coreDataConcerts = []
        container = NSPersistentContainer(name: "ConcertsData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    func fetchConcerts() {
        state = .loading

        let request: NSFetchRequest<ConcertCD> = ConcertCD.fetchRequest()

        container.viewContext.perform {
            do {
                // Execute Fetch Request
                let count = try self.container.viewContext.count(for: request)

                if count == 0 {
                    // no items on Core Data, proceed to parse from json file
                    self.loadFromJson()
                } else {
                    // there is data. then, let's load it
                    let result = try request.execute()
                    if !result.isEmpty {
                        self.concerts = result.map { ConcertViewModel(coreDataModel: $0) }
                        self.coreDataConcerts = result
                        self.state = .loaded
                    }
                }
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }

    func loadFromJson() {
        state = .loading

        concerts = JSONParser.shared.parse(filename: "concerts").map { ConcertViewModel($0) }
        if concerts.isEmpty {
            state = .failed
        } else {
            state = .loaded

            concerts.forEach {
                let cvm = ConcertCD(context: container.viewContext)
                cvm.id = $0.id
                cvm.artist = $0.artist
                cvm.concertHour = $0.concertHour
                cvm.date = $0.date
                cvm.imageURL = $0.imageURL
                cvm.isBookmarked = $0.isBookmarked
                cvm.stageName = $0.stageName
                coreDataConcerts.append(cvm)
            }

            do {
                try container.viewContext.save()
            } catch {
                print("Unable to save data, \(error)")
            }
        }
    }

    func saveBookmark(id: String, isBookmarked: Bool) {
        guard let concert = coreDataConcerts.first(where: { $0.id == id }) else { return }
        concert.isBookmarked = isBookmarked

        do {
            try container.viewContext.save()
        } catch {
            print("Unable to save bookmark, \(error)")
        }
    }
}

extension ConcertViewModel {
    convenience init(coreDataModel: ConcertCD) {
        self.init(
            id: coreDataModel.id ?? "",
            artist: coreDataModel.artist ?? "",
            concertHour: coreDataModel.concertHour ?? "",
            date: coreDataModel.date ?? Date(),
            imageURL: coreDataModel.imageURL,
            isBookmarked: coreDataModel.isBookmarked,
            stageName: coreDataModel.stageName ?? ""
        )
    }
}
