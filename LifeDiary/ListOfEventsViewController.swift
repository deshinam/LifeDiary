import UIKit
import RealmSwift
import GoogleSignIn

class ListOfEventsViewController: UIViewController, UITableViewDelegate, MainProtocol {
    
    private var event2 = Event()
    private var events: Results <Event>?
    private var presenter: ListOfEventsPresenter?
    
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
        presenter = ListOfEventsPresenter(mainProtocol: self)
        eventTableView.dataSource = self
        eventTableView.delegate = self
        let listOfEventsCells = ListOfEventsCells()
        listOfEventsCells.registerCells(eventTableView)
        presenter?.updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.updateData()
    }
    
    private func customizeScreen() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(signOut(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .systemTeal
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIBarButtonItem) {
        goToAddEventViewController(type: .create)
    }
    
    private func goToAddEventViewController (type: AddEventControllerType, event: Event? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addEventVC = storyboard.instantiateViewController(identifier: "eventDetailsViewController") as! EventDetailsViewController
        addEventVC.type = type
        addEventVC.currentEvent = event
        show(addEventVC, sender: nil)
    }
    
    func setEvents(events: Results <Event>?) {
        self.events = events
        eventTableView.reloadData()
    }
    
    @objc func signOut (_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popViewController(animated: true)
        
    }
}


extension ListOfEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        if let item = events?[indexPath.row] {
            let df = DateFormatter()
            cell.eventDate.text = df.getDay(date: item.date)
            cell.eventMonth.text = df.getMonth(date: item.date)
            cell.eventImage.image = UIImage(data: (item.image) as Data)
            cell.eventDescription.text = item.details
            tableView.insertRows(at: [indexPath], with: .fade)
            
        } else {
            cell.eventDescription.text = "No items"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0.25 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        eventTableView.isUserInteractionEnabled = true
        eventTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let row = indexPath.row
        if let curentEvent = events?[row] {
            goToAddEventViewController (type: .show, event: curentEvent)
        }
        
    }
    
}
