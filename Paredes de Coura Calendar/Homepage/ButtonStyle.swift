import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var isSelected: Bool
    var stage: Stage?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Capsule()
                    .fill(isSelected ? color : Color.white)
                    .overlay(
                        Capsule()
                            .stroke(color, lineWidth: isSelected ? 0 : 1)
                    )
            )
            .foregroundColor(isSelected ? Color.white : color)
            .font(isSelected ? Font.body.bold() : .body)
    }

    var color: Color {
        if stage?.name == "Vodafone" {
            return Color.red
        } else if stage?.name == "Yorn" {
            return Color.purple
        } else {
            return Color.black
        }
    }
}
