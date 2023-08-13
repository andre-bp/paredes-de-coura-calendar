import SwiftUI

struct ConcertView: View {
    let viewModel: ConcertViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            AsyncImage(url: viewModel.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 100, height: 100)
            }
            .padding()

            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.concertHour)
                    .padding(.bottom, 12)
                Text(viewModel.artist)
                    .padding(.bottom, 8)
                    .bold()

                HStack(alignment: .center, spacing: 0) {
                    Circle()
                        .fill(.white)
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 8)
                    Text(viewModel.stageName)
                }
            }

            Spacer()
        }
        .background(backgroundColor)
        .contentShape(Rectangle())
    }

    private var backgroundColor: Color {
        if viewModel.stageName == "Vodafone" {
            return Color.red
        } else {
            return Color.purple
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
