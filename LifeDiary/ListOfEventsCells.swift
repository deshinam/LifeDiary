import Foundation
import UIKit

struct ListOfEventsCells {
    
    // MARK:  - Private Properties
    private let eventCellOverview = "EventCell"
    
    // MARK:  - Public Methods
    func registerCells(_ tableView: UITableView) {
        tableView.register(UINib (nibName: eventCellOverview, bundle: nil) , forCellReuseIdentifier: eventCellOverview)
    }

}

