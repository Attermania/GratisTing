import Foundation
import CoreLocation

extension CLLocationManager {
    
    static func isAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .AuthorizedAlways
    }
    
}