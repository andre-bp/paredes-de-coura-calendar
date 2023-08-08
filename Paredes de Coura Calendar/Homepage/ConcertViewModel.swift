import Foundation

final class ConcertViewModel: Identifiable, ObservableObject {

    let id: String
    let artist: String
    let concertHour: String
    let date: Date
    let imageURL: URL?
    @Published var isBookmarked: Bool
    let stageName: String

    init(_ concert: Concert) {
        id = concert.id
        artist = concert.artist.name
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")! // 😬
        let hour = calendar.component(.hour, from: concert.date)
        let minutes = calendar.component(.minute, from: concert.date)
        concertHour = String(hour) + "h" + String(minutes)
        date = concert.date
        imageURL = URL(string: concert.artist.imagePath)
        isBookmarked = false
        stageName = concert.stage.name
    }

    init(
        id: String,
        artist: String,
        concertHour: String,
        date: Date,
        imageURL: URL?,
        isBookmarked: Bool = false,
        stageName: String
    ) {
        self.id = id
        self.artist = artist
        self.concertHour = concertHour
        self.date = date
        self.imageURL = imageURL
        self.isBookmarked = isBookmarked
        self.stageName = stageName
    }
}
