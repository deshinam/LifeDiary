import Foundation
import RealmSwift

struct EventsDatabase {
    
    // MARK:  - Private Properties
    private var realm = try! Realm()
    private var events: Results <Event>?
    private var subscriber: EventsProtocol?
    
    // MARK:  - Public Properties
    static var shared: EventsDatabase = EventsDatabase()
    
    // MARK:  - Initializers
    private init()   {}
    
    // MARK:  - Public Methods
    mutating func loadEvents() -> Results <Event>?  {
        let filter = "userId=" + "\"" + AppData.sharedCurrentUser.user!.userId + "\""
        EventsDatabase.shared.events = realm.objects(Event.self).filter(filter)
        if !(EventsDatabase.shared.events!.isEmpty) {
            EventsDatabase.shared.events = EventsDatabase.shared.events!.sorted(byKeyPath: "date", ascending: false)
        }
        
        return EventsDatabase.shared.events
    }
    
    mutating func saveItems(item: Event) {
        do {
            try realm.write()  {
                realm.add(item)
                if subscriber != nil {
                    subscriber!.updateEventData()
                }
            }
        } catch {
            print (error)
        }
    }
    
    mutating func set(newSubscriber: EventsProtocol?) {
        EventsDatabase.shared.subscriber = newSubscriber
    }
    
    mutating func editItem(editedEventId: Int, newItem: Event) {
        let editedItem = EventsDatabase.shared.events?.filter({ $0.id == editedEventId}).first
        if  editedItem != nil {
            do {
                try realm.write()  {
                    editedItem!.date = newItem.date
                    editedItem!.details = newItem.details
                    editedItem!.image = newItem.image
                    if subscriber != nil {
                        subscriber!.updateEventData()
                    }
                }
            } catch {
                print (error)
            }
        }
    }
    
    mutating func deleteItem(item: Event) {
        
        if let deletedItem = EventsDatabase.shared.events?.filter({ $0.id == item.id }).first {
            do {
                try realm.write()  {
                    realm.delete(deletedItem)
                    if subscriber != nil {
                        subscriber!.updateEventData()
                    }
                }
            } catch {
                print (error)
            }
        }
        
    }
    
    func nextEventId() -> Int {
        let id = realm.objects(Event.self).sorted(byKeyPath: "id", ascending: true).last?.id ?? -1
        return id + 1
    }
    
}


