
import Foundation
import GoogleSignIn

class GoogleSignIn {
    
    static var newUser: User?
    
    func toggleAuthUI() -> Bool {
        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            if let user = GIDSignIn.sharedInstance()!.currentUser {
                AppData.sharedCurrentUser.user = User(userId: user.userID,
                                                      email: user.profile.email,
                                                      name: user.profile.name)
                return true
            }
        }
        
        return false
        
    }
}
