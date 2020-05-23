import Foundation
import GoogleSignIn

struct LoginPresenter {
    
    private var lp : LoginProtocol
    
    init(loginProtocol: LoginProtocol) {
        self.lp = loginProtocol
        GIDSignIn.sharedInstance()?.presentingViewController = lp as! UIViewController
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func signIn() -> Bool {
        return GoogleSignIn().toggleAuthUI()
    }
}


protocol LoginProtocol {
}
