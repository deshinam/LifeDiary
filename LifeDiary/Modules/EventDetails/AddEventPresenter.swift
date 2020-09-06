import Foundation
import RealmSwift
typealias CheckResult = (success: Bool, message: String)

final class AddEventPresenter {
    
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
    
    init (addEventProtocol: AddEventProtocol) {
        self.addEventProtocol = addEventProtocol
    }

    func set(actionType: AddEventControllerType) {
        self.actionType = actionType
    }
    
    func deleteItem() {
        if currentEvent != nil {
            database.deleteItem(item: currentEvent!)
        }
    }
    
    func updateUI() {
        let eventCellFactory = EventCellsFactory()
        let eventDetailsCellArray = eventCellFactory.getCells(type: actionType, tableView: addEventProtocol.getTableView()!, currentEvent)
        addEventProtocol.setCells(eventDetailsCellArray: eventDetailsCellArray)
        addEventProtocol.setActionButtonTitle(title: actionType.rawValue)
        addEventProtocol.reloadData()
    }
    
    private func checkEventData(eventImage: NSData? = nil , eventDate: Date? = nil, eventDescription: String? = "") -> CheckResult {
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
    
    func createEvent(image: NSData?, date: Date?, details: String?, userId: String) -> CheckResult {
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


