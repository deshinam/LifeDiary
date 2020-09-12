import UIKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    
    // MARK:  - IBOutlets
    @IBOutlet private weak var signInButton: GIDSignInButton!
    
    // MARK:  - Private properties
    private var presenter: LoginViewOutput?
    
    // MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(view: self)
        if presenter != nil {
            presenter!.viewDidLoad()
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
