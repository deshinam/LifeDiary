import Foundation

final class AppData {
    // MARK:  - Public Properties
    static var sharedCurrentUser = AppData ()
    var user: User?
    
    // MARK:  - Initializers
    private init () {}
}
