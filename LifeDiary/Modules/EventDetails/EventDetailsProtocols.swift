import UIKit

protocol AddEventViewInput: class {
    func reloadData()
    func getInputData() -> TempEventData
    func showMessage(text: String)
    func hideErrorMessage()
    func dismiss()
    func getTableView() -> UITableView?
    func setActionButtonTitle(title: String)
}

protocol EditCellProtocol {
    func setDate(_ data: Any)
}

protocol AddEventViewOutput {
    func updateUI()
    func deleteItem()
    func actionButtonTapped()
    func setCurrentEvent(event: Event?)
    func getCurrentType() -> AddEventControllerType
    func getCurrentEvent() -> Event?
}
