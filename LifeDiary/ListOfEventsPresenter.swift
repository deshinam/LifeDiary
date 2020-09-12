import Foundation
import RealmSwift
import GoogleSignIn

final class ListOfEventsPresenter: EventsProtocol {
    
    // MARK:  - Private Properties
    private weak var view: ListOfEventsInput?
    private var database: EventsDatabase = EventsDatabase.shared
    private var events: Results <Event>?
    
    // MARK:  - Initializers
    init (view: ListOfEventsInput) {
        self.view = view
        database.set(newSubscriber: self)
    }
}

extension ListOfEventsPresenter: ListOfEventsOutput {
    func updateEventData() {
        self.events = database.loadEvents()
        if view != nil {
            view!.updateTableView()
        }
    }
    
    func getEventsCount() -> Int? {
        return events?.count
    }
    
    func getEventy(by index: Int) -> Event? {
        return events?[index]
    }
    
    func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
    }
}




