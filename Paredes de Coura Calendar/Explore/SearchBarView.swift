import SwiftUI

struct SearchBar: View {

    @Binding var text: String
    let submitClosure: (String) -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(text, text: $text)
                .padding(7)
                .cornerRadius(8)
                .onSubmit {
                    submitClosure(text)
                }
                .onTapGesture {
                    text = ""
                }

        }
        .padding(.all, 4)
        .background(Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(Color(.systemGray6))
        )
    }
}

#if targetEnvironment(simulator)
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), submitClosure: { _ in })
    }
}
#endif
