
import Foundation
import GoogleSignIn

final class GoogleSignIn {
    
    static var newUser: User?
    
    func toggleAuthUI() -> Bool {
        guard
            let signInService = GIDSignIn.sharedInstance(),
            let user = signInService.currentUser,
            user.authentication != nil
        else {
            return false
        }
        
        AppData.sharedCurrentUser.user = User(
            userId: user.userID,
            email: user.profile.email,
            name: user.profile.name
        )
        return true
    }
}
