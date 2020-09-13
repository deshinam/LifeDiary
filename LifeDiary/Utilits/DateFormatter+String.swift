import Foundation

extension DateFormatter {
    func getDay(from date: Date) -> String {
        self.dateFormat = "dd"
        return self.string(from: date)
    }

    func getMonth(from date: Date) -> String {
        self.dateFormat = "MMM"
        return self.string(from: date)
    }

    func getFullDate(from date: Date) -> String {
        self.dateFormat = "dd MMM YYYY"
        return self.string(from: date)
    }
}


