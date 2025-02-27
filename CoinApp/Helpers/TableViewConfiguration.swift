import UIKit

final class TableViewConfiguration<CellType, DataType>: NSObject, UITableViewDataSource, UITableViewDelegate where CellType: UITableViewCell {
    private let tableView: UITableView
    private var data: [DataType] = []
    
    var configureCellForRow: ((_ tableView: UITableView, _ cell: CellType, _ data: DataType) -> Void)?
    var didSelectRow: ((_ tableView: UITableView, _ data: DataType) -> Void)?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CellType.self, forCellReuseIdentifier: String(describing: CellType.self))
    }
    
    func setData(_ data: [DataType]) {
        self.data = data
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            return UITableViewCell()
        }
        
        configureCellForRow?(tableView, cell, data[indexPath.row])
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(tableView, data[indexPath.row])
    }
}
