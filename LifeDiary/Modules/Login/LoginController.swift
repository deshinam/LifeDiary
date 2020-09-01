import UIKit
import GoogleSignIn

class LoginController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    private var loginPresenter: LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter = LoginPresenter(loginProtocol: self)
        loginPresenter!.viewDidLoad()
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

extension LoginController: LoginProtocol {
    func goToApp () {
        self.performSegue(withIdentifier: "goToApp", sender: self)
    }
}
