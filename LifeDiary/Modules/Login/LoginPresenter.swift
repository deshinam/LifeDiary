import Foundation
import GoogleSignIn

class LoginPresenter: NSObject {
    
    private var lp : LoginProtocol?
    
    convenience override init() {
        self.init(loginProtocol: nil)
    }
    
    func viewDidLoad() {
        if self.signIn() {
            lp?.goToApp()
        }
    }
    
    init(loginProtocol: LoginProtocol?) {
        super.init()
        self.lp = loginProtocol
        GIDSignIn.sharedInstance().clientID = Constants.googleSDKClientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = lp as? UIViewController
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func signIn() -> Bool {
        return GoogleSignIn().toggleAuthUI()
    }
}

extension LoginPresenter: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let id = user.userID
            let fullName = user.profile.name
            let email = user.profile.email!
            let currentUser = User(userId: id!, email: email, name: fullName!)
            AppData.sharedCurrentUser.user = currentUser
            lp?.goToApp()
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}

protocol LoginProtocol {
    func goToApp()
}
