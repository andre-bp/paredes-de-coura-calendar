import Foundation

final class ConcertViewModel: Identifiable {

    let id: String
    let artist: String
    let concertHour: String
    let date: Date
    let imageURL: URL?
    let stageName: String

    init(_ concert: Concert) {
        id = concert.id
        artist = concert.artist.name
        let hour = Calendar.current.component(.hour, from: concert.date)
        let minutes = Calendar.current.component(.minute, from: concert.date)
        concertHour = String(hour) + "h" + String(minutes)
        date = concert.date
        imageURL = URL(string: concert.artist.imagePath)
        stageName = concert.stage.name
    }
    
    init(id: String, artist: String, concertHour: String, date: Date, imageURL: URL?, stageName: String) {
        self.id = id
        self.artist = artist
        self.concertHour = concertHour
        self.date = date
        self.imageURL = imageURL
        self.stageName = stageName
    }
}
