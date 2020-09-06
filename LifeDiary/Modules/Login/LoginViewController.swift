import UIKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    private var loginPresenter: LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter = LoginPresenter(loginProtocol: self)
        if loginPresenter != nil {
            loginPresenter!.viewDidLoad()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension LoginViewController: LoginViewInput {
    func goToApp() {
        self.performSegue(withIdentifier: "goToApp", sender: self)
    }
}
