import Foundation

struct Concert: Identifiable {
    let id: String
    let artist: Artist
    let date: Date
    var isBookmarked: Bool
    let stage: Stage
}

#if targetEnvironment(simulator)
extension Concert {
    static func stub(
        id: String = "1",
        artist: Artist = .stub(),
        date: Date = Date(),
        isBookmarked: Bool = false,
        stage: Stage = .stub()
    ) -> Concert {
        Concert(
            id: id,
            artist: artist,
            date: Date(),
            isBookmarked: false,
            stage: stage
        )
    }
}
#endif
