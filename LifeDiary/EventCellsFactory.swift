import UIKit

class EventCellsFactory {
    
    private let EVENT_IMAGE_CELL = "EventImageCell"
    private let EVENT_DATE_EDIT_CELL = "EventDateEditCell"
    private let EVENT_DATE_SHOW_CELL = "EventDateShowCell"
    private let EVENT_DETAILS_EDIT_CELL = "EventDetailsEditCell"
    private let EVENT_DETAILS_SHOW_CELL = "EventDetailsShowCell"
    
    func registerCells (_ tableView: UITableView) {
        [EVENT_IMAGE_CELL,EVENT_DATE_EDIT_CELL,EVENT_DATE_SHOW_CELL,EVENT_DETAILS_EDIT_CELL,EVENT_DETAILS_SHOW_CELL].forEach({
            tableView.register(UINib (nibName: $0, bundle: nil) , forCellReuseIdentifier: $0)
        })
    }
    
    func getCells(type: AddEventControllerType, tableView: UITableView,  _ event: Event? = nil) -> [UITableViewCell] {
        var indexPath: [IndexPath] = []
        for i in 0...2 {
            indexPath.append(IndexPath(row: i, section: 0))
        }
        var detailsViewCells = [UITableViewCell]()
        switch type {
        case .create:
            detailsViewCells = [ tableView.dequeueReusableCell(withIdentifier: EVENT_IMAGE_CELL, for: indexPath[0]),
                                 tableView.dequeueReusableCell(withIdentifier: EVENT_DATE_EDIT_CELL, for: indexPath[1]),
                                 tableView.dequeueReusableCell(withIdentifier: EVENT_DETAILS_EDIT_CELL, for: indexPath[2])]
        case .edit:
            detailsViewCells = [ tableView.dequeueReusableCell(withIdentifier: EVENT_IMAGE_CELL, for: indexPath[0]),
                                 tableView.dequeueReusableCell(withIdentifier: EVENT_DATE_EDIT_CELL, for: indexPath[1]),
                                 tableView.dequeueReusableCell(withIdentifier: EVENT_DETAILS_EDIT_CELL, for: indexPath[2])]
        case .show:
            detailsViewCells = [ tableView.dequeueReusableCell(withIdentifier: EVENT_IMAGE_CELL, for: indexPath[0]),
                                 tableView.dequeueReusableCell(withIdentifier: EVENT_DATE_SHOW_CELL, for: indexPath[1]),
                                 tableView.dequeueReusableCell(withIdentifier: EVENT_DETAILS_SHOW_CELL, for: indexPath[2])]
        }
        
        if event != nil {
            (detailsViewCells[0] as! EventImageCell).eventPhoto.image =  UIImage(data: (event!.image) as Data)
            (detailsViewCells[1] as! EditCellProtocol).setDate(event!.date)
            (detailsViewCells[2] as! EditCellProtocol).setDate(event!.details)
            if type == .show {
                (detailsViewCells[0] as! EventImageCell).imageButton.isHidden = true
            }
        }
        
        return detailsViewCells
    }
}
