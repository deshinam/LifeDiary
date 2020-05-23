import UIKit

class EventCategoryController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var eventCategory: UIButton!
    var categories: [String] = ["Health", "Sport", "Family"]
    
    @IBOutlet weak var categoryEventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryEventTableView.isHidden = true
        categoryEventTableView.dataSource = self
        categoryEventTableView.delegate = self
        categoryEventTableView.register(UINib (nibName: "CategoryEventCell", bundle: nil) , forCellReuseIdentifier: "ReusableCell")
     }
    @IBAction func eventCategoryButtonTapped(_ sender: UIButton) {
        categoryEventTableView.isHidden = false
    }
    
}


extension EventCategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CategoryEventCell
        cell.eventCategory.text = categories[indexPath.row]
        cell.eventColor.backgroundColor = .yellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryEventTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let row = indexPath.row
        eventCategory.setTitle(categories[row], for: .normal)
        categoryEventTableView.isHidden = true
     }
    
}
