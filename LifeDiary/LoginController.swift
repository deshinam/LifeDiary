import UIKit
import GoogleSignIn

class LoginController: UIViewController, LoginProtocol, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    private var loginPresenter: LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = Constants.googleSDKClientId 
        GIDSignIn.sharedInstance().delegate = self
        loginPresenter = LoginPresenter(loginProtocol: self)
        toggleAuthUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func toggleAuthUI() {
        if loginPresenter!.signIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventsVC = storyboard.instantiateViewController(identifier: "eventsViewController") 
            show(eventsVC, sender: nil)
        }
        else {
            signInButton.isHidden = false
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let id = user.userID
            let fullName = user.profile.name
            let email = user.profile.email!
            let currentUser = User(userId: id!, email: email, name: fullName!)
            AppData.sharedCurrentUser.user = currentUser
            self.performSegue(withIdentifier: "goToApp", sender: self)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}
