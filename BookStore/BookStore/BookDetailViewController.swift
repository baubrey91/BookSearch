import Foundation
import UIKit

final class BookDetailViewController: UIViewController {
    
    enum CellType: Int, CaseIterable {
        case id = 0, author, title
    }
    
    enum Constants {
        static let ID = NSLocalizedString("ID", comment: "id value")
        static let author = NSLocalizedString("Author", comment: "author value")
        static let title = NSLocalizedString("Title", comment: "title value")
        static let cellReuseID = "Cell"
    }
    
    private let book: Book
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseID)
        tableView.dataSource = self
        view.addSubview(tableView)
        return tableView
    }()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

extension BookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: Constants.cellReuseID)

        guard let cellType = CellType.init(rawValue: indexPath.row) else { return UITableViewCell() }
        switch cellType {
        case .id:
            cell.textLabel?.text = Constants.ID
            cell.detailTextLabel?.text = book.id
        case .author:
            cell.textLabel?.text = Constants.author
            cell.detailTextLabel?.text = book.author
        case .title:
            cell.textLabel?.text = Constants.title
            cell.detailTextLabel?.text = book.title
        }
        return cell
    }
}
