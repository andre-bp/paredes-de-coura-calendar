import SwiftUI

struct ConcertView: View {
    let viewModel: ConcertViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
//            AsyncImage(url: viewModel.imageURL)
            Image(systemName: "music.mic")
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.concertHour)

                Text(viewModel.artist)

                Text(viewModel.stageName)
            }

            Spacer()
        }
    }
}

#if targetEnvironment(simulator)
struct ConcertView_Previews: PreviewProvider {
    static var previews: some View {
        ConcertView(viewModel: ConcertViewModel(.stub()))
    }
}
#endif
