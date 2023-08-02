import Foundation

struct Festival {
    let artists: [Artist]
    let concerts: [Concert]
    let dates: [Date]
    let name: String
    let stages: [Stage]
}

#if targetEnvironment(simulator)

extension Festival {
    static func stub(
        artists: [Artist] = [.stub()],
        concerts: [Concert] = [.stub()],
        dates: [Date] = [Date()],
        name: String = "Vodafone Paredes de Coura",
        stages: [Stage] = [.stub()]
    ) -> Festival {
        .init(artists: artists, concerts: concerts, dates: dates, name: name, stages: stages)
    }
}

#endif
