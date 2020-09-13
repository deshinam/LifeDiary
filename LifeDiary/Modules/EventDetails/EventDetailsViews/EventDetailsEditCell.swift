import UIKit

final class EventDetailsEditCell: UITableViewCell, UITextViewDelegate {
    
    // MARK:  - IBOutlets
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK:  - Lyfecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.systemGray5.cgColor
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.delegate = self
    }
    
    // MARK:  - Public Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EventDetailsEditCell: EditCellProtocol {
    func setDate(_ data: Any) {
        descriptionTextView.text = data as? String
    }
}
