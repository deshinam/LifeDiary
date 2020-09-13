import Foundation

protocol ListOfEventsInput: class {
    func updateTableView()
}

protocol ListOfEventsOutput {
    func updateEventData()
    func getEventsCount() -> Int?
    func getEventy(by index: Int) -> Event?
    func signOut()
}
