import UIKit

class EventDateEditCell: UITableViewCell, EditCellProtocol {
    
    @IBOutlet weak var dateText: UIButton!
    var eventDate: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDate(_:)),
                                               name: NSNotification.Name(rawValue: "SetEventDate"),
                                               object: nil)
    }
    
    @objc func updateDate(_ sender: Notification) {
        print ("update\(DateFormatter().getFullDate(date: (sender.userInfo?["selectedDate"] as? Date)!))")
        if let date = sender.userInfo?["selectedDate"] as? Date {
            eventDate = date
            print ("eventData\(DateFormatter().getFullDate(date: eventDate!))")
            setDate(eventDate)
            print (DateFormatter().getFullDate(date: date))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDate(_ data: Any) {
        dateText.setTitleColor(UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1.0), for: .normal)
        eventDate = data as! Date
        dateText.setTitle(DateFormatter().getFullDate(date: eventDate!), for: .normal)
        print ("Set data")
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "ShowCalendar"),
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
