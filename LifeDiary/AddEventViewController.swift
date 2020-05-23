//import UIKit
//
//class AddEventViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AddEventProtocol  {
//
//    var type: AddEventControllerType = .create
//    var actionButton: UIBarButtonItem?
//    var currentEvent: Event?
//    var addEventPresenter: AddEventPresenter?
//    var image: NSData?
//    @IBOutlet weak var errorLabel: UILabel!
//    @IBOutlet weak var eventPhoto: UIImageView!
//    var imagePicker = UIImagePickerController()
//    private var datePicker: UIDatePicker?
//    @IBOutlet weak var dateText: UITextField!
//    @IBOutlet weak var descriptionTextView: UITextView!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var detailsLabel: UILabel!
//    @IBOutlet weak var deleteEventButton: UIButton!
//    @IBOutlet weak var dateTitleLabel: UILabel!
//    @IBOutlet weak var detailsTitileLable: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.backBarButtonItem?.title = "Close"
//        descriptionTextView!.layer.borderWidth = 1
//        descriptionTextView!.layer.borderColor = UIColor.gray.cgColor
//        datePicker = UIDatePicker()
//        datePicker?.datePickerMode = .date
//        dateText.inputView = datePicker

//        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(AddEventViewController.backgroundTap(gestureRecogniser:)))
//        view.addGestureRecognizer(tapGesture)
//        addEventPresenter = AddEventPresenter(addEventProtocol: self)
//        let tapImageGesture = UITapGestureRecognizer (target: self, action: #selector(addPhotoButtonTapped(_:)))
//        eventPhoto.isUserInteractionEnabled = true
//        eventPhoto.addGestureRecognizer(tapImageGesture)
//        actionButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(actionButtonTapped(_:)))
//        self.navigationItem.rightBarButtonItem = actionButton
//        createScreen()
//
//    }
//
//    func createScreen() {
//        errorLabel.isHidden = true
//        actionButton?.title = type.rawValue
////        dateText.layer.cornerRadius = 5
////        descriptionTextView.layer.cornerRadius = 5
////        eventPhoto.layer.cornerRadius = 5
////        dateText.layer.borderColor = UIColor.systemGray5.cgColor
////        dateText.layer.borderWidth = 2
////        descriptionTextView.layer.borderColor = UIColor.systemGray5.cgColor
////        descriptionTextView.layer.borderWidth = 2
//        navigationController?.navigationBar.barTintColor = UIColor.white
//        switch type {
//            case .create:
//                descriptionTextView.isEditable = true
//                dateText.isUserInteractionEnabled = true
//                eventPhoto.isUserInteractionEnabled = true
//                eventPhoto.backgroundColor = .systemGray6
//                detailsTitileLable.isHidden = false
//                detailsLabel.isHidden = true
//                dateLabel.isHidden = true
//                descriptionTextView.isHidden = false
//                dateText.isHidden = false
//                deleteEventButton.isHidden = true
//                dateTitleLabel.isHidden = false
//
//            case .show:
//                eventPhoto.image =  UIImage(data: (currentEvent?.image)! as Data)
//                eventPhoto.backgroundColor = .none
//                descriptionTextView.isEditable = false
//                descriptionTextView.isHidden = true
//                detailsTitileLable.isHidden = true
//                detailsLabel.isHidden = false
//                detailsLabel.text = "\"" + currentEvent!.details + "\""
//                dateText.isUserInteractionEnabled = false
//                dateText.isHidden = true
//                dateLabel.isHidden = false
//                dateLabel.text = currentEvent?.getFullDate()
//                eventPhoto.isUserInteractionEnabled = false
//                deleteEventButton.isHidden = false
//                dateTitleLabel.isHidden = true
//
//            case .edit:
//                descriptionTextView.text = currentEvent?.details
//                dateText.text = currentEvent?.getFullDate()
//                eventPhoto.image =  UIImage(data: (currentEvent?.image)! as Data)
//                eventPhoto.backgroundColor = .none
//                descriptionTextView.isEditable = true
//                dateText.isUserInteractionEnabled = true
//                eventPhoto.isUserInteractionEnabled = true
//                detailsTitileLable.isHidden = false
//                detailsLabel.isHidden = true
//                dateLabel.isHidden = true
//                descriptionTextView.isHidden = false
//                dateText.isHidden = false
//                deleteEventButton.isHidden = false
//                dateTitleLabel.isHidden = false
//        }
//    }
//
//
//    @IBAction func deleteEventButtonTapped(_ sender: UIButton) {
//        addEventPresenter?.deleteItem(item: currentEvent!)
//    }
//
//    @objc func actionButtonTapped(_ sender: UIBarButtonItem) {
//        switch type {
//        case .create:
//            addButtonTapped()
//        case .show:
//            editButtonTapped()
//        case .edit:
//            saveButtonTapped()
//        }
//    }
//
//    func checkEventData () -> String? {
//        var errorMesage = ""
//        if  dateText.text == "" {
//            errorMesage = errorMesage + " " + ErrorMessage.noDate.rawValue + ","
//        }
//        if  descriptionTextView.text == "" {
//            errorMesage = errorMesage + " " + ErrorMessage.noDetails.rawValue + ","
//        }
//        if  eventPhoto.image == nil {
//            errorMesage = errorMesage + " " + ErrorMessage.noImage.rawValue + ","
//        }
//        if errorMesage != "" {
//            errorMesage.removeLast()
//        }
//
//        return errorMesage
//    }
//
//    func addButtonTapped() {
//        let errorMesage = checkEventData()
//
//        if  (errorMesage == "")
//        {
//            errorLabel.isHidden = true
//            let newEvent = Event (date: datePicker!.date,
//                                  details: descriptionTextView.text,
//                                  image:  NSData(data: (eventPhoto.image?.jpegData(compressionQuality: 0.9))!),
//                                  userId: AppData.sharedCurrentUser.user!.userId)
//            addEventPresenter?.addEvent(newEvent: newEvent)
//            navigationController?.popViewController(animated: true)
//            //self.dismiss(animated: true, completion: nil)
//        }
//        else
//        {
//            errorLabel.isHidden = false
//            errorLabel.text = "You haven't completed the following fields:" + errorMesage!
//        }
//
//    }
//
//    func editButtonTapped () {
//        type = .edit
//        createScreen()
//    }
//
//    func saveButtonTapped () {
//        let errorMesage = checkEventData()
//
//        if  (errorMesage == "")
//        {
//            errorLabel.isHidden = true
//            let newEvent = Event (date: datePicker!.date,
//                                  details: descriptionTextView.text,
//                                  image: NSData(data: (eventPhoto.image?.jpegData(compressionQuality: 0.9))!),
//                                  userId: AppData.sharedCurrentUser.user!.userId)
//            addEventPresenter?.editEvent(oldItem: currentEvent!, newItem: newEvent)
//          //  self.dismiss(animated: true, completion: nil)
//            }
//        else
//        {
//                errorLabel.isHidden = false
//                errorLabel.text = "You haven't completed the following fields:" + errorMesage!
//        }
//    }
//
//    @objc func backgroundTap (gestureRecogniser: UITapGestureRecognizer) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateText.text = dateFormatter.string(from: datePicker!.date)
//        view.endEditing(true)
//    }
//
//    @objc func addPhotoButtonTapped (_ sender: UIButton) {
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("Button capture")
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum
//            imagePicker.allowsEditing = false
//            present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            eventPhoto.contentMode = .scaleAspectFit
//            eventPhoto.image = userPickedImage
//            image = NSData (data:  userPickedImage.jpegData (compressionQuality: 0.9)!)
//        }
//        imagePicker.dismiss(animated: true, completion: nil)
//
//    }
//
//    func showError() {
//        print ("error")
//    }
//
//
//}
