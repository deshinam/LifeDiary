
import UIKit

struct Constants {
    static let googleSDKClientId1 = "1033599919942-sag920l97oi1tlitu9j"
    static let googleSDKClientId2 = "51mc3nlvrq16i.apps.googleusercontent.com"
    
    static let grayColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1.0)
}

extension Notification.Name {
    static let showCalendar = Notification.Name("ShowCalendar")
    static let openImagePicker = Notification.Name("OpenImagePicker")
    static let setEventDate = Notification.Name("SetEventDate")
}
