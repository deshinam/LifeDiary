import Foundation
import RealmSwift


class User: Object {
    
    @objc dynamic var userId: String
    @objc dynamic var email: String
    @objc dynamic var name: String
    
    init (userId: String, email: String, name: String) {
        self.userId = userId
        self.email = email
        self.name = name
    }
    
    required init() {
        userId = ""
        email = ""
        name = ""
        // fatalError("init() has not been implemented")
    }
    
}
