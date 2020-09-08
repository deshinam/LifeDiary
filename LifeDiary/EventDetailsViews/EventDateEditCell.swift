import UIKit

final class EventDateEditCell: UITableViewCell {
    
    // MARK:  - IBOutlets
    @IBOutlet private weak var dateText: UIButton!
    
    // MARK:  - Public Properties
    var eventDate: Date?
    
    // MARK:  - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDate(_:)),
                                               name: .setEventDate,
                                               object: nil)
    }
    
    // MARK:  - Public Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:  - Private Methods
    @objc private func updateDate(_ sender: Notification) {
        if let date = sender.userInfo?["selectedDate"] as? Date {
            eventDate = date
            setDate(eventDate as Any)
        }
    }
    
    private func customizeButton() {
        dateText.layer.cornerRadius = 5
        dateText.layer.borderColor = UIColor.systemGray5.cgColor
        dateText.layer.borderWidth = 2
        dateText.setTitleColor(.systemGray4, for: .normal)
        dateText.contentHorizontalAlignment = .left
    }
    
    // MARK:  - IBActions
    @IBAction private func dateButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name:  .showCalendar,
                                        object: nil)
    }
}

extension EventDateEditCell: EditCellProtocol {
    func setDate(_ data: Any) {
        dateText.setTitleColor(Constants.grayColor, for: .normal)
        eventDate = data as? Date
        dateText.setTitle(DateFormatter().getFullDate(from: eventDate!), for: .normal)
    }
}
