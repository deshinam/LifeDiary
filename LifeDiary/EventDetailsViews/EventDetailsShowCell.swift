import UIKit

class EventDetailsShowCell: UITableViewCell, EditCellProtocol {

    @IBOutlet weak var detailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setDate(_ data: Any) {
        detailsLabel.text = "\"" + (data  as! String) + "\""
    }
    
}
