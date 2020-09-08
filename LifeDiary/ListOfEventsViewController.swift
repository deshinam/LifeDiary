import UIKit
import RealmSwift

final class ListOfEventsViewController: UIViewController, UITableViewDelegate, MainProtocol {
    
    // MARK:  - IBOutlets
    @IBOutlet private weak var eventTableView: UITableView!
    
    // MARK:  - Private Properties
    private var presenter: ListOfEventsPresenter?
    
    // MARK:  - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
        presenter = ListOfEventsPresenter(mainProtocol: self)
        eventTableView.dataSource = self
        eventTableView.delegate = self
        let listOfEventsCells = ListOfEventsCells()
        listOfEventsCells.registerCells(eventTableView)
        presenter?.updateEventData()
    }
    
    // MARK:  - Public Methods
    func updateTableView() {
         eventTableView.reloadData()
    }
    
    // MARK:  - Private Methods
    private func customizeScreen() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(signOut(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .systemTeal
    }
    
    private func goToAddEventViewController(type: AddEventControllerType, event: Event? = nil) {
        let addDetailsViewBuilder = AddDetailsViewBuilder()
        let builder = addDetailsViewBuilder.create(type: type, event: event) as! EventDetailsViewController
        show(builder, sender: nil)
    }
    
    @objc private func signOut(_ sender: Any) {
        presenter?.signOut()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK:  - IBActions
    @IBAction private func addEventButtonTapped(_ sender: UIBarButtonItem) {
        goToAddEventViewController(type: .create)
    }
}

// MARK:  - Table View Data Source
extension ListOfEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getEventsCount() ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        if let item = presenter?.getEventy(by: indexPath.row) {
            let df = DateFormatter()
            cell.eventDate.text = df.getDay(date: item.date)
            cell.eventMonth.text = df.getMonth(from: item.date)
            cell.eventImage.image = UIImage(data: (item.image) as Data)
            cell.eventDescription.text = item.details
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
        if let curentEvent = presenter?.getEventy(by: indexPath.row) {
            goToAddEventViewController (type: .show, event: curentEvent)
        }
    }
    
}
