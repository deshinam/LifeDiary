import UIKit

class EventImageCell: UITableViewCell {
    
    @IBOutlet weak var eventPhoto: UIImageView!
   
    @IBOutlet weak var imageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        eventPhoto.layer.cornerRadius = 5
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name:  .openImagePicker,
                                        object: nil)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
