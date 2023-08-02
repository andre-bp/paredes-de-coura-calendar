import SwiftUI

struct ExploreView: View {
    var body: some View {
        VStack {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Pesquisa")
                        .bold()
                        .padding(.bottom, 8)
                    
                    SearchBar(text: .constant("Pesquisa um artista aqui"), submitClosure: { _ in })
                    
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            
            Divider()
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
