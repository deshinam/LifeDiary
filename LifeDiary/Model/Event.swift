import Foundation
import RealmSwift

final class Event: Object {
    
    @objc dynamic var id: Int
    @objc dynamic var date: Date
    @objc dynamic var details: String
    @objc dynamic var image: NSData
    @objc dynamic var userId: String
    
    init(id: Int, date: Date, details: String, image: NSData, userId: String) {
        self.id = id
        self.date = date
        self.details = details
        self.image = image
        self.userId = userId
    }
    
    required init() {
        id = 0
        date = Date()
        details = " "
        image = NSData()
        userId = ""
    }
    
}

