import Foundation

final class AppData {
    static var sharedCurrentUser = AppData ()
    var user: User?
    
    private init () {}
}
