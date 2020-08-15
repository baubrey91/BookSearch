import Foundation
import UIKit

protocol BookAPI {
    func getBookCollection(completion: @escaping (Result<[Book], Error>) -> Void)
    func getBookImage(imagePath: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

final class BookClient: BookAPI {
    let service: NetworkService
    
    public init(netService: NetworkService? = nil) {
        self.service = netService ?? NetworkService()
    }
    
    func getBookCollection(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let request = bookRequest(collection: "books.json") else {
            DispatchQueue.global().async {
                completion(.failure(ServiceError.requestError))
            }
            return
        }
        service.get(request: request) { (result: Result<Data, Error>) in
            do {
                switch result {
                case .success(let data):
                    let bookCollection: BookCollection = try! JSONDecoder().decode(BookCollection.self, from: data)
                    completion(.success(bookCollection.books))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getBookImage(imagePath: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let request = bookRequest(imagePath: imagePath) else {
            DispatchQueue.global().async {
                completion(.failure(ServiceError.requestError))
            }
            return
        }
        service.get(request: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)!
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
