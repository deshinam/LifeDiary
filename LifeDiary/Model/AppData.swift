import Foundation

class AppData {
    
    static var sharedCurrentUser: AppData = {return AppData()} ()
    var user: User?
    
    private init () {}
}
