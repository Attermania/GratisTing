import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var dao: DAOProtocol!
    static var authentication: Authentication!
    
    override init() {
        AppDelegate.dao = DAO.instance
        AppDelegate.authentication = Authentication.instance
    }

}