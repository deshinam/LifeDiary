import Foundation
import RealmSwift
typealias CheckResult = (success: Bool, message: String)

final class AddEventPresenter {
    
    // MARK:  - Private Properties
    private weak var view: AddEventViewInput?
    private var database: EventsDatabase = EventsDatabase.shared
    private var currentEvent: Event?
    private var actionType: AddEventControllerType = .create {
        didSet {
            if view!.getTableView() != nil {
                updateUI()
            }
        }
    }
    
     // MARK:  - Initializers
    init (view: AddEventViewInput) {
        self.view = view
    }

    // MARK:  - Public Methods
    func set(actionType: AddEventControllerType) {
        self.actionType = actionType
    }
    
    // MARK:  - Private Methods
    private func checkEventData(eventImage: Data? = nil , eventDate: Date? = nil, eventDescription: String? = "") -> CheckResult {
        var errorMesage = ""
        if  eventDate == nil {
            errorMesage += " " + ErrorMessage.noDate.rawValue + ","
        }
        if  eventDescription == "" {
            errorMesage += " " + ErrorMessage.noDetails.rawValue + ","
        }
        if  eventImage == nil {
            errorMesage += " " + ErrorMessage.noImage.rawValue + ","
        }
        if errorMesage != "" {
            errorMesage.removeLast()
        }
        return (errorMesage == "", errorMesage)
    }
    
    private func save() {
        guard view != nil else {
            return
        }
        let tempData: TempEventData = view!.getInputData()
        let result = createEvent(image: tempData.image,
                                 date: tempData.date,
                                 details: tempData.details,
                                 userId: tempData.userId)
        if result.success {
            view!.hideErrorMessage()
            view!.dismiss()
        } else {
            view!.showMessage(text: result.message)
        }
    }
    
    private func createEvent(image: Data?, date: Date?, details: String?, userId: String) -> CheckResult {
        let errorMessage = checkEventData(eventImage: image, eventDate: date, eventDescription: details)
        if  (errorMessage.success)
        {
            let newEvent = Event(id: database.nextEventId(), date: date!, details: details!, image: image!, userId: userId)
            if actionType == .create {
                database.saveItems(item: newEvent)
            }
            else if actionType == .edit && currentEvent != nil {
                database.editItem(editedEventId: currentEvent!.id, newItem: newEvent)
            }
        }
        else
        {
            return (false, "You haven't completed the following fields: \(errorMessage.message)")
        }
        return (true, "")
    }
}

extension AddEventPresenter: AddEventViewOutput {
    func updateUI() {
        if view != nil {
            view!.setActionButtonTitle(title: actionType.rawValue)
            view!.reloadData()
        }
    }
    
    func deleteItem() {
        if currentEvent != nil {
            database.deleteItem(item: currentEvent!)
        }
    }
    
    func actionButtonTapped() {
        switch actionType {
        case .create, .edit:
            save()
        case .show:
            actionType = .edit
        }
    }
    
    func setCurrentEvent(event: Event?) {
        currentEvent = event
    }
    
    func getCurrentType() -> AddEventControllerType {
        return actionType
    }
    
    func getCurrentEvent() -> Event? {
        return currentEvent
    }
}


