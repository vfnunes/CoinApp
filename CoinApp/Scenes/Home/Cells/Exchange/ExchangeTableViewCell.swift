import UIKit

extension ExchangeTableViewCell.Layout {
    enum Spacing {
        static let itemSpacing = 8.0
    }
}

final class ExchangeTableViewCell: UITableViewCell {
    fileprivate enum Layout { }
    
    private lazy var exchangeIdLabel: UILabel = {
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
    
    private lazy var volume1DayUsdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exchangeIdLabel, nameLabel, volume1DayUsdLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layout.Spacing.itemSpacing
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        exchangeIdLabel.text = nil
        nameLabel.text = nil
        volume1DayUsdLabel.text = nil
    }
    
    func setupViewModel(_ viewModel: ExchangeViewModel) {
        exchangeIdLabel.text = viewModel.exchangeId
        nameLabel.text = viewModel.name
        volume1DayUsdLabel.text = viewModel.volume1DayUsd
    }
    
    // MARK: - Private Methods
    private func buildLayout() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.Spacing.itemSpacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.Spacing.itemSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.Spacing.itemSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.Spacing.itemSpacing)
        ])
    }
}
