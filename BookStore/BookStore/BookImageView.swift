import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

final class BookImageView: UIImageView {
    private var imagePath: String?
    private var bookClient = BookClient()
    
    public func imageFromServerURL(imagePath: String) {
        
        self.imagePath = imagePath
        
        if let image = imageCache.object(forKey: NSString(string: imagePath)) {
            if self.imagePath == imagePath {
                self.image = image
            }
            return
        }

        bookClient.getBookImage(imagePath: imagePath) { result in
            switch result {
            case .success(let image):
                guard let image = image else { return }
                imageCache.setObject(image, forKey: NSString(string: imagePath))
                if self.imagePath == imagePath {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
