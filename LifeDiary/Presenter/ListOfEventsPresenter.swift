import Foundation
import RealmSwift

struct ListOfEventsPresenter: EventsProtocol {
    
    private var vc: MainProtocol
    private var events: EventsData = EventsData.shared
    
    init (mainProtocol: MainProtocol) {
        vc = mainProtocol
        events.set(newSubscriber: self)
    }

    mutating func updateData()  {
        vc.setEvents(events: events.loadEvents())
    }
    
    mutating func updated() {
        updateData()
    }
}

protocol MainProtocol {
    func setEvents (events: Results <Event>?)
}




