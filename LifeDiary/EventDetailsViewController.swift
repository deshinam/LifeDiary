import Foundation
import UIKit
typealias TempEventData = (image: Data?, date: Date?, details: String?, userId: String)

final class EventDetailsViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, AddEventViewInput, UINavigationControllerDelegate {
    
    // MARK:  - IBOutlets
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var eventDetailsTableView: UITableView!
    @IBOutlet private weak var eventTableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK:  - Private Properties
    private let eventImageCell = "EventImageCell"
    private let eventDateEditCell = "EventDateEditCell"
    private let eventDateShowCell = "EventDateShowCell"
    private let eventDetailsEditCell = "EventDetailsEditCell"
    private let eventDetailsShowCell = "EventDetailsShowCell"
    
    private var actionButton: UIBarButtonItem?
    private var imagePicker = UIImagePickerController()
    private var presenter: AddEventViewOutput?
    private var image: Data?
    private let keyboardHeight: CGFloat = 200
    private let eventTableViewBottomConstraintStart: CGFloat = 30
    private let cellCount = 3
    private let imageCellIndex = 0
    private let detailsCellIndex = 2
    
    // MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
        eventDetailsTableView.dataSource = self
        eventDetailsTableView.delegate = self
        registerCells()
        presenter?.updateUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCalendar(_:)),
                                               name: .showCalendar,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addPhotoButtonTapped(_:)),
                                               name: .openImagePicker,
                                               object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:  - Public Methods
    func getInputData() -> TempEventData {
        let indexPath = generateIndexPath()
        let eventImage = (eventDetailsTableView.cellForRow(at: indexPath[0])  as! EventImageCell).eventPhoto.image
        let eventDate =  (eventDetailsTableView.cellForRow(at: indexPath[1])  as! EventDateEditCell).eventDate
        let eventDescription = (eventDetailsTableView.cellForRow(at: indexPath[2]) as! EventDetailsEditCell).descriptionTextView.text
        
        return (image: Data (((eventImage?.jpegData(compressionQuality: 0.9)))!),
                date: eventDate,
                details: eventDescription,
                userId: AppData.sharedCurrentUser.user!.userId)
    }
    
    func getTableView() -> UITableView? {
        return eventDetailsTableView
    }
    
    func reloadData() {
        eventDetailsTableView.reloadData()
    }
    
    func setActionButtonTitle(title: String) {
        actionButton?.title = title
    }
    
    func showMessage(text: String) {
        errorLabel.isHidden = false
        errorLabel.text = text
    }
    
    func hideErrorMessage() {
        errorLabel.isHidden = true
    }
    
    func setPresenter(presenter: AddEventViewOutput) {
        self.presenter = presenter
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            (getCell(with: imageCellIndex) as! EventImageCell).eventPhoto.contentMode = .scaleAspectFit
            (getCell(with: imageCellIndex) as! EventImageCell).eventPhoto.image = userPickedImage
            image = Data (userPickedImage.jpegData (compressionQuality: 0.9)!)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK:  - Private Methods
    private func registerCells() {
        [eventImageCell,eventDateEditCell,eventDateShowCell,eventDetailsEditCell,eventDetailsShowCell].forEach({
            eventDetailsTableView.register(UINib (nibName: $0, bundle: nil) , forCellReuseIdentifier: $0)
        })
    }
    
    private func customizeScreen() {
        navigationItem.backBarButtonItem?.title = "Close"
        navigationController?.navigationBar.tintColor = .systemTeal
        actionButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(actionButtonTapped(_:)))
        navigationItem.rightBarButtonItem = actionButton
        errorLabel.isHidden = true
    }
    
    private func getCell(with row: Int ) -> UITableViewCell? {
        let cellIndexPath = IndexPath(row: row, section: 0)
        return eventDetailsTableView.cellForRow(at: cellIndexPath)!
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        (getCell(with: detailsCellIndex) as! EventDetailsEditCell).descriptionTextView.becomeFirstResponder()
        eventTableViewBottomConstraint.constant = eventTableViewBottomConstraintStart + keyboardHeight
        let offset = CGPoint(x: 0, y: eventDetailsTableView.contentSize.height)
        eventDetailsTableView.setContentOffset(offset, animated: true)
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        eventTableViewBottomConstraint.constant = eventTableViewBottomConstraintStart
    }
    
    @objc private func showCalendar(_ sender: Any?) {
        let calendarVC = UIStoryboard().getControllerBy(id: "calendarViewController")
        calendarVC.modalPresentationStyle = .popover
        present(calendarVC, animated: true, completion: nil)
    }
    
    @objc private func actionButtonTapped(_ sender: UIBarButtonItem) {
        presenter?.actionButtonTapped()
    }

    @objc private func addPhotoButtonTapped(_ sender: Any?) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func generateIndexPath() -> [IndexPath] {
        var indexPath: [IndexPath] = []
        for i in 0...2 {
            indexPath.append(IndexPath(row: i, section: 0))
        }
        return indexPath
    }
    
    // MARK:  - IBActions
    @IBAction private func eventDeleteButtonTapped(_ sender: UIButton) {
        presenter?.deleteItem()
        navigationController?.popViewController(animated: true)
    }
}

// MARK:  - Table View Data Source
extension EventDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard presenter != nil else {
            return cell
        }
        let actionType = presenter!.getCurrentType()
        switch  actionType {
           
        case .create, .edit:
            switch indexPath.row {
            case 0: cell = tableView.dequeueReusableCell(withIdentifier: eventImageCell, for: indexPath)
            case 1: cell = tableView.dequeueReusableCell(withIdentifier: eventDateEditCell, for: indexPath)
            case 2: cell = tableView.dequeueReusableCell(withIdentifier: eventDetailsEditCell, for: indexPath)
            default:
                break
            }
        case .show:
            switch indexPath.row {
                    case 0: cell = tableView.dequeueReusableCell(withIdentifier: eventImageCell, for: indexPath)
                    case 1: cell = tableView.dequeueReusableCell(withIdentifier: eventDateShowCell, for: indexPath)
                    case 2: cell = tableView.dequeueReusableCell(withIdentifier: eventDetailsShowCell, for: indexPath)
                    default:
                        break
                    }
        }
        
        if let event = presenter?.getCurrentEvent() {
            switch indexPath.row {
            case 0: (cell as! EventImageCell).eventPhoto.image =  UIImage(data: (event.image) as Data)
            case 1: (cell as! EditCellProtocol).setDate(event.date)
            case 2: (cell as! EditCellProtocol).setDate(event.details)
            default:
                break
            }
            if actionType == .show && indexPath.row == 0 {
                (cell as! EventImageCell).imageButton.isHidden = true
            }
        }
        
        return cell
    }
    
}
