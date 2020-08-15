//
//  BookCollectionViewController.swift
//  BookStore
//

import UIKit

class BookCollectionViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    
    enum Section {
        case main
    }
    
    enum Constants {
        static let navigationTitle = NSLocalizedString("Book Store", comment: "book collection title")
        static let collectionViewPadding: CGFloat = 10
        static let collectionViewCellReuseID = "BookCell"
        static let requestFailedPrompt = NSLocalizedString("Network request failed, please try again", comment: "request failed prompt")
        static let tryAgainPrompt = NSLocalizedString("Try Again", comment: "try again prompt")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let bookClient = BookClient()
    private var originalBooks = [Book]()
    private var filteredBooks = [Book]()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, book) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellReuseID, for: indexPath) as? BookCollectionViewCell
                cell?.bookImageView.imageFromServerURL(imagePath: book.imagePath)
                return cell
        })
        return dataSource
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setNavigationItem()
        getBooks()
        applySnapshot(animatingDifferences: false)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredBooks)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setCollectionView() {
        collectionView.contentInset.left = Constants.collectionViewPadding
        collectionView.contentInset.right = Constants.collectionViewPadding
    }
    
    private func setNavigationItem() {
        navigationItem.title = Constants.navigationTitle
        navigationItem.titleView = searchBar
    }
    
    private func getBooks() {
        bookClient.getBookCollection(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let bookCollection):
                strongSelf.originalBooks = bookCollection
                strongSelf.filteredBooks = bookCollection
                DispatchQueue.main.async {
                    strongSelf.applySnapshot()
                }
            case .failure(_):
                ///Log error here
                strongSelf.showAlert()
            }
        })
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: nil, message: Constants.requestFailedPrompt, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.tryAgainPrompt, style: .default, handler: { [weak self] _ in
            self?.getBooks()
        })
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

extension BookCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        let viewController = BookDetailViewController(book: book)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.threeRowSize(with: Constants.collectionViewPadding)
    }
}

extension BookCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBooks = searchText.isEmptyOrWhiteSpace ? originalBooks : originalBooks.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.author.lowercased().contains(searchText.lowercased())}
        applySnapshot()
    }
}
