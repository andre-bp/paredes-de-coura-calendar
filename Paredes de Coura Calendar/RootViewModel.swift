import Foundation

final class RootViewModel {
    let homepageViewModel: HomepageViewModel
    let exploreViewModel: ExploreViewModel

    let concerts: [Concert]
    let stages: [Stage]
    
    let festivalDates: [FestivalDate] = [
        FestivalDate(id: "1", date: Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 16)) ?? Date()),
        FestivalDate(id: "2", date: Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 17)) ?? Date()),
        FestivalDate(id: "3", date: Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 18)) ?? Date()),
        FestivalDate(id: "4", date: Calendar.current.date(from: DateComponents(year:2023, month: 8, day: 19)) ?? Date())
    ]
    
    init() {
        let artist = Artist(id:"1", name: "Fever Ray", imagePath: "")
        let stage = Stage(id:"1", name: "Vodafone")
        let blackMidi = Artist(id: "3", name: "black midi", imagePath: "")
        let snailMail = Artist(id:"2", name: "Snail Mail", imagePath: "")
        let jessieWare = Artist(id: "4", name: "Jessie Ware", imagePath: "")
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 16, hour: 21, minute: 30))
        
        concerts = [
            Concert(id:"1", artist: artist, date: date ?? Date() , isBookmarked: false, stage: stage),
            Concert(id: "2", artist: snailMail, date: festivalDates[2].date, isBookmarked: false, stage: stage),
            Concert(id: "3", artist: blackMidi, date: festivalDates[1].date, isBookmarked: false, stage: stage),
            Concert(id:"4", artist: jessieWare, date: festivalDates[0].date, isBookmarked: false, stage: stage)
        ]
        stages = [stage]
        homepageViewModel = HomepageViewModel(dates: festivalDates, concerts: concerts)
        exploreViewModel = ExploreViewModel()
    }
}
