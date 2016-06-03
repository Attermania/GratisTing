import Foundation

class Category {
    
    var id: String?
    var title: String = ""
    var imageURL: String = ""
    
    init(id: String, title: String, imageURL: String) {
        self.id    = id
        self.title = title
        self.imageURL = imageURL
    }
    
    init(title: String) {
        self.title = title
    }
}