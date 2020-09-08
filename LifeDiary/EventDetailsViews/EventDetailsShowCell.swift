import UIKit

final class EventDetailsShowCell: UITableViewCell {

    // MARK:  - IBOutlets
    @IBOutlet private weak var detailsLabel: UILabel!
    
    // MARK:  - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK:  - Public Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension EventDetailsShowCell: EditCellProtocol {
    func setDate(_ data: Any) {
        detailsLabel.text = "\"" + (data  as! String) + "\""
    }
}
