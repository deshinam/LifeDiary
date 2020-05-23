import Foundation
import RealmSwift

struct AddEventPresenter: EventsProtocol {
    
    private var addEventProtocol: AddEventProtocol
    private var events: EventsData = EventsData.shared
    
    init (addEventProtocol: AddEventProtocol) {
        self.addEventProtocol = addEventProtocol
    }
    

    mutating func deleteItem (item: Event) {
        events.deleteItem(item: item)
    }
    
    mutating func updated() {

    }

    
    mutating func createEvent(image: NSData, date: Date, details: String, userId: String, editedEventId: Int? = nil, actionType: AddEventControllerType) -> Bool {
        let newEvent = Event(id: events.nextEventId(), date: date, details: details, image: image, userId: userId)
        if actionType == .create {
            events.saveItems(item: newEvent)
        }
        else if actionType == .edit {
            events.editItem(editedEventId: editedEventId!, newItem: newEvent)
        }
        return true
    }
}

protocol AddEventProtocol {
    func showError ()
}
