import UIKit

class EventDateEditCell: UITableViewCell, EditCellProtocol {
    
    @IBOutlet weak var dateText: UIButton!
    var eventDate: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDate(_:)),
                                               name: .setEventDate,
                                               object: nil)
    }
    
    @objc func updateDate(_ sender: Notification) {
        if let date = sender.userInfo?["selectedDate"] as? Date {
            eventDate = date
            setDate(eventDate as Any)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDate(_ data: Any) {
        dateText.setTitleColor(Constants.grayColor, for: .normal)
        eventDate = data as? Date
        dateText.setTitle(DateFormatter().getFullDate(date: eventDate!), for: .normal)
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name:  .showCalendar,
                                        object: nil)
    }
    
    private func customizeButton () {
        dateText.layer.cornerRadius = 5
        dateText.layer.borderColor = UIColor.systemGray5.cgColor
        dateText.layer.borderWidth = 2
        dateText.setTitleColor(.systemGray4, for: .normal)
        dateText.contentHorizontalAlignment = .left
    }
    
}
