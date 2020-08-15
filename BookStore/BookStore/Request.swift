import Foundation

public protocol Requests {
    var url: URL { get }
}

private var baseUrl: String = "http://0.0.0.0:8000/"

public struct bookRequest: Requests {
    public let url: URL
    
    ///I am aware that these are the exact same but you may have a different server for images in the future
    public init?(collection: String) {
        let urlString = baseUrl + collection
        guard let url = URL(string: urlString) else { return nil }
        self.url = url
    }
    
    public init?(imagePath: String) {
        let urlString = baseUrl + imagePath
        guard let url = URL(string: urlString) else { return nil }
        self.url = url
    }
}
