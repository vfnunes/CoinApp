import UIKit

protocol HomeDisplaying: AnyObject {
    func startLoading()
    func stopLoading()
    func showError(_ message: String)
    func configureViewModels(_ viewModels: [ExchangeViewModel])
}

final class HomeViewController: UIViewController {
    private let interactor: HomeInteractoring
    
    private lazy var tableViewConfiguration: TableViewConfiguration<ExchangeTableViewCell, ExchangeViewModel> = {
        let tableViewConfiguration = TableViewConfiguration<ExchangeTableViewCell, ExchangeViewModel>(tableView: tableView)
        tableViewConfiguration.configureCellForRow = { _, cell, data in
            cell.setupViewModel(data)
        }
        tableViewConfiguration.didSelectRow = { [weak self] _, viewModel in
            self?.interactor.showExchangeDetail(from: viewModel.data)
        }
        return tableViewConfiguration
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        activityIndicatorView.color = .darkGray
        return activityIndicatorView
    }()
    
    init(interactor: HomeInteractoring) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        title = "Exchange List"
        interactor.loadData()
    }
    
    // MARK: - Private Methods
    private func buildLayout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.backgroundColor = .systemBackground
    }
}

extension HomeViewController: HomeDisplaying {
    func startLoading() {
        tableView.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        tableView.isHidden = false
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func showError(_ message: String) {
        let retryAction = UIAlertAction(title: "Tentar novamente", style: .default) { [weak self] _ in
            self?.interactor.loadData()
        }
        
        let alertController = UIAlertController(title: "Ops! Algo deu errado", message: message, preferredStyle: .alert)
        alertController.addAction(retryAction)
        
        present(alertController, animated: true)
    }
    
    func configureViewModels(_ viewModels: [ExchangeViewModel]) {
        tableViewConfiguration.setData(viewModels)
    }
}
