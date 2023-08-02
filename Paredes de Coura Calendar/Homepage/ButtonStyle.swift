import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.black : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: isSelected ? 0 : 2)
                    )
            )
            .foregroundColor(isSelected ? Color.white : Color.black)
            .font(isSelected ? Font.body.bold() : .body)
    }
}
