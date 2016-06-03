import Foundation

class User {
    
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var phoneNumber: Int?
    var items:[Item] = []
    var address: Address
    
    /*
     Constructor without id parameter. Used when creating User object in the app. Id will be assigned in DB.
     */
    init(email: String, password: String, name: String, address: Address) {
        self.email = email
        self.password = password
        self.name = name
        self.address = address
    }
    
    /**
     Constructor with id attribute. Used when parsing JSON to User object.
     */
    init(id: String, email: String, name: String, address: Address) {
        self.id = id
        self.email = email
        self.name = name
        self.address = address
    }

}
