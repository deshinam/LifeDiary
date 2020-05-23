import Foundation
import UIKit

struct ListOfEventsCells {
    
    private let EVENT_CELL_OVERVIEW = "EventCell"
    
    func registerCells (_ tableView: UITableView) {
        tableView.register(UINib (nibName: EVENT_CELL_OVERVIEW, bundle: nil) , forCellReuseIdentifier: EVENT_CELL_OVERVIEW)
    }

}

