import UIKit

final class EventDateShowCell: UITableViewCell, EditCellProtocol {
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDate(_ data: Any) {
        dateLabel.text = DateFormatter().getFullDate(from: data as! Date)
    }
    
}
