import Foundation
import RealmSwift
typealias CheckResult = (success: Bool, message: String)

final class AddEventPresenter {
    
    // MARK:  - Private Properties
    private var addEventProtocol: AddEventProtocol
    private var database: EventsDatabase = EventsDatabase.shared
    private var currentEvent: Event?
    private var actionType: AddEventControllerType = .create {
        didSet {
            if addEventProtocol.getTableView() != nil { 
                updateUI()
            }
        }
    }
    
     // MARK:  - Initializers
    init (addEventProtocol: AddEventProtocol) {
        self.addEventProtocol = addEventProtocol
    }

    // MARK:  - Public Methods
    func set(actionType: AddEventControllerType) {
        self.actionType = actionType
    }
    
    func updateUI() {
        let eventCellFactory = EventCellsFactory()
        let eventDetailsCellArray = eventCellFactory.getCells(type: actionType, tableView: addEventProtocol.getTableView()!, currentEvent)
        addEventProtocol.setCells(eventDetailsCellArray: eventDetailsCellArray)
        addEventProtocol.setActionButtonTitle(title: actionType.rawValue)
        addEventProtocol.reloadData()
    }
    
    func deleteItem() {
        if currentEvent != nil {
            database.deleteItem(item: currentEvent!)
        }
    }
    
    func createEvent(image: Data?, date: Date?, details: String?, userId: String) -> CheckResult {
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
    
    func getCurrentEvent() -> Event? {
        return currentEvent
    }
    
    func setCurrentEvent(event: Event?) {
        currentEvent = event
    }
    
    func actionButtonTapped() {
        switch actionType {
        case .create, .edit:
            save()
        case .show:
            actionType = .edit
        }
    }
    
    // MARK:  - Private Methods
    private func checkEventData(eventImage: Data? = nil , eventDate: Date? = nil, eventDescription: String? = "") -> CheckResult {
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
        return (errorMesage == "", errorMesage)
    }
    
    private func save() {
        let tempData: TempEventData = addEventProtocol.getInputData()
        let result = createEvent(image: tempData.image,
                                 date: tempData.date,
                                 details: tempData.details,
                                 userId: tempData.userId)
        if result.success {
            addEventProtocol.hideErrorMessage()
            addEventProtocol.dismiss()
        } else {
            addEventProtocol.showMessage(text: result.message)
        }
    }
}


