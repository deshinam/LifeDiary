import Foundation
import UIKit

struct EventDetailsCells {
    
    private let EVENT_IMAGE_CELL = "EventImageCell"
    private let EVENT_DATE_EDIT_CELL = "EventDateEditCell"
    private let EVENT_DATE_SHOW_CELL = "EventDateShowCell"
    private let EVENT_DETAILS_EDIT_CELL = "EventDetailsEditCell"
    private let EVENT_DETAILS_SHOW_CELL = "EventDetailsShowCell"
    

    
    func getDetailsViewCells (_ tableView: UITableView, _ event: Event? = nil) -> Dictionary<AddEventControllerType,[UITableViewCell]>? {
        var indexPath: [IndexPath] = []
        for i in 0...2 {
            indexPath.append(IndexPath(row: i, section: 0))
        }
        
        let detailsViewCells: Dictionary<AddEventControllerType,[UITableViewCell]> = [
            .create: [
                tableView.dequeueReusableCell(withIdentifier: EVENT_IMAGE_CELL, for: indexPath[0]),
                tableView.dequeueReusableCell(withIdentifier: EVENT_DATE_EDIT_CELL, for: indexPath[1]),
                tableView.dequeueReusableCell(withIdentifier: EVENT_DETAILS_EDIT_CELL, for: indexPath[2])],
            .edit: [
                tableView.dequeueReusableCell(withIdentifier: EVENT_IMAGE_CELL, for: indexPath[0]),
                tableView.dequeueReusableCell(withIdentifier: EVENT_DATE_EDIT_CELL, for: indexPath[1]),
                tableView.dequeueReusableCell(withIdentifier: EVENT_DETAILS_EDIT_CELL, for: indexPath[2])],
            
            .show: [
                tableView.dequeueReusableCell(withIdentifier: EVENT_IMAGE_CELL, for: indexPath[0]),
                tableView.dequeueReusableCell(withIdentifier: EVENT_DATE_SHOW_CELL, for: indexPath[1]),
                tableView.dequeueReusableCell(withIdentifier: EVENT_DETAILS_SHOW_CELL, for: indexPath[2])],
        ]
        
        if event != nil {
            let types: [AddEventControllerType] =  [.show, .edit]
            types.forEach({ type in
                (detailsViewCells[type]![0] as! EventImageCell).eventPhoto.image =  UIImage(data: (event!.image) as Data)
                
                (detailsViewCells[type]![1] as! EditCellProtocol).setDate(event!.date)
                (detailsViewCells[type]![2] as! EditCellProtocol).setDate(event!.details)
            })
            (detailsViewCells[.show]![0] as! EventImageCell).imageButton.isHidden = true
        }
        
        return detailsViewCells
    }
    
}
