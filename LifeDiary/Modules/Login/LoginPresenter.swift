import Foundation
import GoogleSignIn

final class LoginPresenter: NSObject {
    
    // MARK:  - Private properties
    private weak var view : LoginViewInput?

    // MARK:  - Initializers
    init(loginProtocol: LoginViewInput?) {
        super.init()
        self.view = loginProtocol
        GIDSignIn.sharedInstance().clientID = Constants.googleSDKClientId1 + Constants.googleSDKClientId2
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = view as? UIViewController
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    convenience override init() {
        self.init(loginProtocol: nil)
    }
    
    // MARK:  - Lifecycle
    func viewDidLoad() {
        if self.signIn() {
            view?.goToApp()
        }
    }

    // MARK:  - Private Methods
    private func signIn() -> Bool {
        return GoogleSignIn().toggleAuthUI()
    }
}

extension LoginPresenter: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            guard
                let id = user.userID,
                let fullName = user.profile.name,
                let email = user.profile.email
            else {
                return
            }
            AppData.sharedCurrentUser.user =  User(userId: id,
                                                     email: email,
                                                     name: fullName)
            view?.goToApp()

        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}


