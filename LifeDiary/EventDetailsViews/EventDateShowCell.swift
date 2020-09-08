import UIKit

final class EventDateShowCell: UITableViewCell {
    
    // MARK:  - IBOutlets
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK:  - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK:  - Public Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension EventDateShowCell: EditCellProtocol {
    func setDate(_ data: Any) {
        dateLabel.text = DateFormatter().getFullDate(from: data as! Date)
    }
}
