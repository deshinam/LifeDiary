import Foundation

extension DateFormatter {
    func getDay (date: Date) -> String {
        self.dateFormat = "dd"
        return self.string(from: date)
    }

    func getMonth (date: Date) -> String {
        self.dateFormat = "MMM"
        return self.string(from: date)
    }

    func getFullDate (date: Date) -> String {
        self.dateFormat = "dd MMM YYYY"
        return self.string(from: date)
    }
}

