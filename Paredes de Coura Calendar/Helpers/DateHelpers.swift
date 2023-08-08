import Foundation

extension Date {
    func dayMonthYearComponents() -> DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year], from: self)
    }

    func formattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: self)

        return "\(dateString), \(weekday())"
    }

    func weekday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }

    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
}
