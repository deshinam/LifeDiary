import UIKit

struct AddDetailsViewBuilder {
    
    func create (type: AddEventControllerType, event: Event? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addEventVC = storyboard.instantiateViewController(identifier: "eventDetailsViewController") as! EventDetailsViewController
        let addEventPresenter = AddEventPresenter(addEventProtocol: addEventVC)
        addEventVC.setPresenter(addEventPresenter: addEventPresenter)
        addEventPresenter.setCurrentEvent(event: event)
        addEventPresenter.set(actionType: type)
        return addEventVC
    }
}
