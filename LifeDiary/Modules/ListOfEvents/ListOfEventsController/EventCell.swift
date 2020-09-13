import UIKit

final class EventCell: UITableViewCell {
    
    // MARK:  - IBOutlets
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventMonth: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventView: UIView!
    
    // MARK:  - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        eventView.layer.cornerRadius = 10.0
        eventImage.layer.cornerRadius = 10.0
    }
    
    // MARK:  - Public Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
