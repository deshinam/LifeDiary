import Foundation
import UIKit


class EventDetailsViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, AddEventProtocol, UINavigationControllerDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var eventDetailsTableView: UITableView!
    @IBOutlet weak var eventTableViewBottomConstraint: NSLayoutConstraint!
    var type: AddEventControllerType = .create
    private var actionButton: UIBarButtonItem?
    var currentEvent: Event?
    private var imagePicker = UIImagePickerController()
    private var addEventPresenter: AddEventPresenter?
    private var eventDetailsCellArray: Dictionary<AddEventControllerType,[UITableViewCell]>?
    private var image: NSData?
    private let keyboardHeight: CGFloat = 200
    private let eventTableViewBottomConstraintStart: CGFloat = 30
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
        eventDetailsTableView.dataSource = self
        eventDetailsTableView.delegate = self
        let eventDetailsCells = EventDetailsCells()
        eventDetailsCells.registerCells(eventDetailsTableView)
        addEventPresenter = AddEventPresenter(addEventProtocol: self)
        
        eventDetailsCellArray = eventDetailsCells.getDetailsViewCells(eventDetailsTableView, currentEvent)
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
    
    func showError() {
    }
    
    @objc func keyboardWillShow (_ sender: Notification) {
        ((eventDetailsCellArray?[type]![2])! as! EventDetailsEditCell).descriptionTextView.becomeFirstResponder()
        eventTableViewBottomConstraint.constant = eventTableViewBottomConstraintStart + keyboardHeight
        let offset = CGPoint(x: 0, y: eventDetailsTableView.contentSize.height)
       eventDetailsTableView.setContentOffset(offset, animated: true)
    }
    
    @objc func keyboardWillHide (_ sender: Notification) {
        eventTableViewBottomConstraint.constant = eventTableViewBottomConstraintStart
    }
    
    @objc func showCalendar(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarVC = storyboard.instantiateViewController(identifier: "calendarViewController")
        calendarVC.modalPresentationStyle = .popover
        self.present(calendarVC, animated: true, completion: nil)

    }
    
    @objc private func actionButtonTapped(_ sender: UIBarButtonItem) {
        switch type {
        case .create:
            addButtonTapped()
        case .show:
            editButtonTapped()
        case .edit:
            saveButtonTapped()
        }
    }
    
    private func checkEventData (eventImage: UIImage? = nil , eventDate: Date? = nil, eventDescription: String? = "") -> String? {
        var errorMesage = ""
        if  eventDate == nil {
            errorMesage = errorMesage + " " + ErrorMessage.noDate.rawValue + ","
        }
        if  eventDescription == "" {
            errorMesage = errorMesage + " " + ErrorMessage.noDetails.rawValue + ","
        }
        if  eventImage == nil {
            errorMesage = errorMesage + " " + ErrorMessage.noImage.rawValue + ","
        }
        if errorMesage != "" {
            errorMesage.removeLast()
        }
        return errorMesage
    }
    
    private func addButtonTapped() {
        if getNewEventData() {
            errorLabel.isHidden = true
         //   addEventPresenter?.addEvent(newEvent: getNewEventData()!)
            navigationController?.popViewController(animated: true)
        } else {
            errorLabel.isHidden = false
        }
    }
    
    
    private func editButtonTapped() {
        type = .edit
        eventDetailsTableView.reloadData()
    }
    
    private func saveButtonTapped() {
        if getNewEventData(){
            
            errorLabel.isHidden = true
            navigationController?.popViewController(animated: true)
        } else {
            errorLabel.isHidden = false
        }
    }
    
    
    private func getNewEventData() -> Bool {
        var indexPath: [IndexPath] = []
        var status: Bool? = false
        var editedEventId: Int?
        for i in 0...2 {
            indexPath.append(IndexPath(row: i, section: 0))
        }
        let eventImage = (eventDetailsTableView.cellForRow(at: indexPath[0])  as! EventImageCell).eventPhoto.image
        let eventDate =  (eventDetailsTableView.cellForRow(at: indexPath[1])  as! EventDateEditCell).eventDate
        let eventDescription = (eventDetailsTableView.cellForRow(at: indexPath[2]) as! EventDetailsEditCell).descriptionTextView.text
        let errorMessage = checkEventData(eventImage: eventImage, eventDate: eventDate, eventDescription: eventDescription)
        if type == .edit {
            editedEventId = currentEvent?.id
        }
        if  (errorMessage == "")
        {
            status = addEventPresenter?.createEvent(image: NSData(data: ((eventImage?.jpegData(compressionQuality: 0.9))!)),
                                           date: eventDate!,
                                           details: eventDescription!,
                                           userId: AppData.sharedCurrentUser.user!.userId,
                                           editedEventId: editedEventId,
                                           actionType: type
                                        )
        }
        else
        {
            errorLabel.text = "You haven't completed the following fields:" + errorMessage!
        }
        return status ?? false
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
            if type != .show {
                (eventDetailsCellArray![type]![0] as! EventImageCell).eventPhoto.contentMode = .scaleAspectFit
                (eventDetailsCellArray![type]![0] as! EventImageCell).eventPhoto.image = userPickedImage
            }
            image = NSData (data:  userPickedImage.jpegData (compressionQuality: 0.9)!)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventDeleteButtonTapped(_ sender: UIButton) {
        addEventPresenter?.deleteItem(item: currentEvent!)
        navigationController?.popViewController(animated: true)
    }
    
}

extension EventDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        actionButton?.title = type.rawValue
        return eventDetailsCellArray![type]![indexPath.row]
    }

    
}


