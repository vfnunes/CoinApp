import UIKit

protocol DetailDisplaying: AnyObject {
    func configureDetailView(_ detailDTO: DetailDTO)
}

extension DetailViewController.Layout {
    enum Spacing {
        static let itemSpacing = 8.0
    }
}

final class DetailViewController: UIViewController {
    fileprivate enum Layout { }
    
    private let interactor: DetailInteractoring
    
    private lazy var exchangeIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        return label
    }()
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var volume1hrsUsdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var volume1dayUsdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var volume1mthUsdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            exchangeIdLabel,
            nameLabel,
            rankLabel,
            websiteLabel,
            volume1hrsUsdLabel,
            volume1dayUsdLabel,
            volume1mthUsdLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layout.Spacing.itemSpacing
        return stackView
    }()
    
    init(interactor: DetailInteractoring) {
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
        interactor.loadData()
    }
    
    private func buildLayout() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Spacing.itemSpacing),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.Spacing.itemSpacing),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.Spacing.itemSpacing),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.backgroundColor = .systemBackground
    }
}

extension DetailViewController: DetailDisplaying {
    func configureDetailView(_ detailDTO: DetailDTO) {
        exchangeIdLabel.text = detailDTO.exchangeId
        nameLabel.text = detailDTO.name
        rankLabel.text = detailDTO.rank
        websiteLabel.text = detailDTO.website
        volume1hrsUsdLabel.text = detailDTO.volume1hrsUsd
        volume1dayUsdLabel.text = detailDTO.volume1dayUsd
        volume1mthUsdLabel.text = detailDTO.volume1mthUsd
    }
}
