import UIKit

extension UIStoryboard {
    func getController(by id: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: id)
        return vc
    }
}
