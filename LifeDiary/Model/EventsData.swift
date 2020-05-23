import Foundation
import RealmSwift

struct EventsData {
    
    private var realm = try! Realm()
    private var events: Results <Event>?
    private var subscriber: EventsProtocol?
    
    static var shared: EventsData = EventsData()

    private init()   {}
    
    mutating func loadEvents () -> Results <Event>?  {
        let filter = "userId=" + "\"" + AppData.sharedCurrentUser.user!.userId + "\""
        EventsData.shared.events = realm.objects(Event.self).filter(filter)
        if !(EventsData.shared.events!.isEmpty) {
            EventsData.shared.events = EventsData.shared.events!.sorted(byKeyPath: "date", ascending: false)
        }
        
        return EventsData.shared.events
    }
    
    mutating func saveItems ( item: Event) {
        do {
            try realm.write()  {
                realm.add(item)
                if subscriber != nil {
                    subscriber!.updated()
                }
            }
        } catch {
            print (error)
        }
    }
    
    mutating func set (newSubscriber: EventsProtocol?) {
        EventsData.shared.subscriber = newSubscriber
    }
    
    mutating func editItem (editedEventId: Int, newItem: Event) {
        let editedItem = EventsData.shared.events?.filter({ $0.id == editedEventId}).first
        if  editedItem != nil {
            do {
                try realm.write()  {
                    editedItem!.date = newItem.date
                    editedItem!.details = newItem.details
                    editedItem!.image = newItem.image
                    if subscriber != nil {
                        subscriber!.updated()
                    }
                }
            } catch {
                print (error)
            }
        }
    }
    
    mutating func deleteItem (item: Event) {
        
        if let deletedItem = EventsData.shared.events?.filter({ $0.id == item.id }).first {
            do {
                       try realm.write()  {
                           realm.delete(deletedItem)
                           if subscriber != nil {
                               subscriber!.updated()
                           }
                       }
                   } catch {
                       print (error)
                   }
        }
       
    }
    
    func nextEventId () -> Int {
        let id = realm.objects(Event.self).sorted(byKeyPath: "id", ascending: true).last?.id ?? -1
        return id + 1
    }
    
}

protocol EventsProtocol {
    
    mutating func updated ()
    
}
