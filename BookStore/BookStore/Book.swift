import Foundation
import UIKit

//Although this seems unnecessary in the future a book collection might have an ID or other data
struct BookCollection: Decodable {
    var books: [Book]
}

struct Book: Decodable {
    let uuid = UUID()
    var id: String
    var title: String
    var author: String
    
    var imagePath: String {
        id + ".jpg"
    }
}

extension Book: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
