import UIKit
import GoogleSignIn

class LoginController: UIViewController, LoginProtocol, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    private var loginPresenter: LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "1033599919942-sag920l97oi1tlitu9j51mc3nlvrq16i.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        loginPresenter = LoginPresenter(loginProtocol: self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        toggleAuthUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    private func toggleAuthUI() {
        if loginPresenter!.signIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventsVC = storyboard.instantiateViewController(identifier: "eventsViewController") 
            show(eventsVC, sender: nil)
            //            self.performSegue(withIdentifier: "goToApp", sender: self)
        }
        else {
            signInButton.isHidden = false
        }
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
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
