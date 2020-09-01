import Foundation
import UIKit
typealias TempEventData = (image: NSData?, date: Date?, details: String?, userId: String)

class EventDetailsViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, AddEventProtocol, UINavigationControllerDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var eventDetailsTableView: UITableView!
    @IBOutlet weak var eventTableViewBottomConstraint: NSLayoutConstraint!
    private var actionButton: UIBarButtonItem?
    private var imagePicker = UIImagePickerController()
    private var addEventPresenter: AddEventPresenter?
    private var eventDetailsCellArray: [UITableViewCell] = [] {
        didSet {
            print( "value set")
        }
    }
    private var image: NSData?
    private let keyboardHeight: CGFloat = 200
    private let eventTableViewBottomConstraintStart: CGFloat = 30
    var supervalue = 0
    
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
    
    private func customizeScreen() {
        self.navigationItem.backBarButtonItem?.title = "Close"
        self.navigationController?.navigationBar.tintColor = .systemTeal
        actionButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(actionButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = actionButton
        errorLabel.isHidden = true
    }
    
    @objc func keyboardWillShow (_ sender: Notification) {
        ((eventDetailsCellArray[2]) as! EventDetailsEditCell).descriptionTextView.becomeFirstResponder()
        eventTableViewBottomConstraint.constant = eventTableViewBottomConstraintStart + keyboardHeight
        let offset = CGPoint(x: 0, y: eventDetailsTableView.contentSize.height)
        eventDetailsTableView.setContentOffset(offset, animated: true)
    }
    
    @objc func keyboardWillHide (_ sender: Notification) {
        eventTableViewBottomConstraint.constant = eventTableViewBottomConstraintStart
    }
    
    @objc func showCalendar(_ sender: Any?) {
        supervalue = 5
        let calendarVC = UIStoryboard().getControllerBy(id: "calendarViewController")
        calendarVC.modalPresentationStyle = .popover
        self.present(calendarVC, animated: true, completion: nil)
    }
    
    @objc private func actionButtonTapped(_ sender: UIBarButtonItem) {
        addEventPresenter?.actionButtonTapped()
    }
    
    func reloadData () {
        eventDetailsTableView.reloadData()
    }
    
    func getInputData() -> TempEventData {
        let indexPath = generateIndexPath()
        let eventImage = (eventDetailsTableView.cellForRow(at: indexPath[0])  as! EventImageCell).eventPhoto.image
        let eventDate =  (eventDetailsTableView.cellForRow(at: indexPath[1])  as! EventDateEditCell).eventDate
        let eventDescription = (eventDetailsTableView.cellForRow(at: indexPath[2]) as! EventDetailsEditCell).descriptionTextView.text
        
        return (image: NSData(data: ((eventImage?.jpegData(compressionQuality: 0.9)))!),
                date: eventDate,
                details: eventDescription,
                userId: AppData.sharedCurrentUser.user!.userId)
    }
    
    private func generateIndexPath() -> [IndexPath] {
        var indexPath: [IndexPath] = []
        for i in 0...2 {
            indexPath.append(IndexPath(row: i, section: 0))
        }
        return indexPath
    }
    
    func showMessage(text: String) {
        errorLabel.isHidden = false
        errorLabel.text = text
    }
    
    func hideErrorMessage() {
        errorLabel.isHidden = true
    }
    
    func setCells(eventDetailsCellArray: [UITableViewCell]) {
        self.eventDetailsCellArray = eventDetailsCellArray
    }
    
    @objc private func addPhotoButtonTapped (_ sender: Any?) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            (eventDetailsCellArray[0] as! EventImageCell).eventPhoto.contentMode = .scaleAspectFit
            (eventDetailsCellArray[0] as! EventImageCell).eventPhoto.image = userPickedImage
            image = NSData (data:  userPickedImage.jpegData (compressionQuality: 0.9)!)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventDeleteButtonTapped(_ sender: UIButton) {
        addEventPresenter?.deleteItem()
        navigationController?.popViewController(animated: true)
    }
    
    func setPresenter(addEventPresenter: AddEventPresenter) {
        self.addEventPresenter = addEventPresenter
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func getTableView() -> UITableView? {
        return eventDetailsTableView
    }
    
    func setActionButtonTitle(title: String) {
        actionButton?.title = title
    }
    
}

extension EventDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDetailsCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return eventDetailsCellArray[indexPath.row]
    }
    
}


