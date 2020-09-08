import UIKit

final class EventImageCell: UITableViewCell {
    
    // MARK:  - IBOutlets
    @IBOutlet weak var eventPhoto: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    // MARK:  - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        eventPhoto.layer.cornerRadius = 5
    }
    
    // MARK:  - Public Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:  - IBBActions
    @IBAction private func imageButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name:  .openImagePicker,
                                        object: nil)
    }
}
