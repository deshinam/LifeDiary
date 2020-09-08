import UIKit

final class EventCellsFactory {
    
    // MARK:  - Private Properties
    private let eventImageCell = "EventImageCell"
    private let eventDateEditCell = "EventDateEditCell"
    private let eventDateShowCell = "EventDateShowCell"
    private let eventDetailsEditCell = "EventDetailsEditCell"
    private let eventDetailsShowCell = "EventDetailsShowCell"
    
    // MARK:  - Public Methods
    func registerCells(_ tableView: UITableView) {
        [eventImageCell,eventDateEditCell,eventDateShowCell,eventDetailsEditCell,eventDetailsShowCell].forEach({
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
            detailsViewCells = [ tableView.dequeueReusableCell(withIdentifier: eventImageCell, for: indexPath[0]),
                                 tableView.dequeueReusableCell(withIdentifier: eventDateEditCell, for: indexPath[1]),
                                 tableView.dequeueReusableCell(withIdentifier: eventDetailsEditCell, for: indexPath[2])]
        case .edit:
            detailsViewCells = [ tableView.dequeueReusableCell(withIdentifier: eventImageCell, for: indexPath[0]),
                                 tableView.dequeueReusableCell(withIdentifier: eventDateEditCell, for: indexPath[1]),
                                 tableView.dequeueReusableCell(withIdentifier: eventDetailsEditCell, for: indexPath[2])]
        case .show:
            detailsViewCells = [ tableView.dequeueReusableCell(withIdentifier: eventImageCell, for: indexPath[0]),
                                 tableView.dequeueReusableCell(withIdentifier: eventDateShowCell, for: indexPath[1]),
                                 tableView.dequeueReusableCell(withIdentifier: eventDetailsShowCell, for: indexPath[2])]
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
