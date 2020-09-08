import Foundation
import UIKit
typealias TempEventData = (image: Data?, date: Date?, details: String?, userId: String)

final class EventDetailsViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, AddEventProtocol, UINavigationControllerDelegate {
    
    // MARK:  - IBOutlets
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var eventDetailsTableView: UITableView!
    @IBOutlet private weak var eventTableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK:  - Private Properties
    private var actionButton: UIBarButtonItem?
    private var imagePicker = UIImagePickerController()
    private var addEventPresenter: AddEventPresenter?
    private var eventDetailsCellArray: [UITableViewCell] = []
    private var image: Data?
    private let keyboardHeight: CGFloat = 200
    private let eventTableViewBottomConstraintStart: CGFloat = 30
    
    // MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
        eventDetailsTableView.dataSource = self
        eventDetailsTableView.delegate = self
        let eventDetailsCells = EventCellsFactory()
        eventDetailsCells.registerCells(eventDetailsTableView)
        addEventPresenter?.updateUI()
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
    
    func setCells(eventDetailsCellArray: [UITableViewCell]) {
        self.eventDetailsCellArray = eventDetailsCellArray
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
    
    func setPresenter(addEventPresenter: AddEventPresenter) {
        self.addEventPresenter = addEventPresenter
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            (eventDetailsCellArray[0] as! EventImageCell).eventPhoto.contentMode = .scaleAspectFit
            (eventDetailsCellArray[0] as! EventImageCell).eventPhoto.image = userPickedImage
            image = Data (userPickedImage.jpegData (compressionQuality: 0.9)!)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK:  - Private Methods
    private func customizeScreen() {
        navigationItem.backBarButtonItem?.title = "Close"
        navigationController?.navigationBar.tintColor = .systemTeal
        actionButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(actionButtonTapped(_:)))
        
        navigationItem.rightBarButtonItem = actionButton
        errorLabel.isHidden = true
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        ((eventDetailsCellArray[2]) as! EventDetailsEditCell).descriptionTextView.becomeFirstResponder()
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
        addEventPresenter?.actionButtonTapped()
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
        addEventPresenter?.deleteItem()
        navigationController?.popViewController(animated: true)
    }
}

// MARK:  - Table View Data Source
extension EventDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDetailsCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return eventDetailsCellArray[indexPath.row]
    }
    
}


