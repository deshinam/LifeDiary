import UIKit

protocol AddEventProtocol {
    func reloadData()
    func getInputData() -> TempEventData
    func showMessage(text: String)
    func hideErrorMessage()
    func dismiss()
    func getTableView() -> UITableView?
    func setCells(eventDetailsCellArray: [UITableViewCell])
    func setActionButtonTitle(title: String)
}

protocol EditCellProtocol {
    func setDate(_ data: Any)
}
