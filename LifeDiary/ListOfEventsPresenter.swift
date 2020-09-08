import Foundation
import RealmSwift
import GoogleSignIn

final class ListOfEventsPresenter: EventsProtocol {
    
    private weak var view: MainProtocol?
    private var database: EventsDatabase = EventsDatabase.shared
    private var events: Results <Event>?
    
    init (mainProtocol: MainProtocol) {
        view = mainProtocol
        database.set(newSubscriber: self)
    }
    
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

protocol MainProtocol: class {
    func updateTableView()
}




