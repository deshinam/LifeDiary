import UIKit

extension UIStoryboard {
    func getControllerBy(id: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: id)
        return vc
    }
}
