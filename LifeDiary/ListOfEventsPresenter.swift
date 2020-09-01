import Foundation
import RealmSwift
import GoogleSignIn

class ListOfEventsPresenter: EventsProtocol {
    
    private var vc: MainProtocol
    private var database: EventsDatabase = EventsDatabase.shared
    private var events: Results <Event>?
    
    init (mainProtocol: MainProtocol) {
        vc = mainProtocol
        database.set(newSubscriber: self)
    }
    
    func updateEventData() {
        self.events = database.loadEvents()
        vc.updateTableView()
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

protocol MainProtocol {
    func updateTableView()
}




