import UIKit

class StockListCell: UITableViewCell {
    
    static let identifier = "StockListCell"
    
    private var isGrowing = Bool()
    private let containerView = UIView()
    private let stockImageView = UIImageView()
    private let symbolLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let changePercentLabel = UILabel()
    private let favouriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: StockViewModel) {
        
        isGrowing = returnDirection(change: data.change)
        
        symbolLabel.text = data.symbol
        titleLabel.text = data.name
        priceLabel.text = "$\(String(data.price))"
        changeLabel.text = "\(isGrowing ? "+" : "-")$\(String(abs(data.change)))"
        changeLabel.textColor = isGrowing ? UIColor.changeIncreasingLabelColor() : UIColor.changeDecreasingLabelColor()
        changePercentLabel.text = "(\(String(abs(data.changePercent)))%)"
        changePercentLabel.textColor = isGrowing ? UIColor.changeIncreasingLabelColor() : UIColor.changeDecreasingLabelColor()
        
        stockImageView.load(with: URL(string: data.logoURL)!)
    }
    
    private func setUpUI() {
        setUpContainerView()
        setUpImageView()
        setUpStockTitle()
        setUpStockInfo()
    }
    
    private func setUpContainerView() {
        
        contentView.addSubview(containerView)
        
        containerView.backgroundColor = .clear
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setUpImageView() {
        
        containerView.addSubview(stockImageView)
        
        stockImageView.translatesAutoresizingMaskIntoConstraints = false
        
        stockImageView.layer.cornerRadius = 12
        stockImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            stockImageView.widthAnchor.constraint(equalToConstant: 70),
            stockImageView.heightAnchor.constraint(equalToConstant: 70),
            stockImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stockImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        
    }
    
    private func setUpStockTitle() {
        
        let stackView = UIStackView(arrangedSubviews: [symbolLabel, titleLabel])
        
        containerView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        symbolLabel.font = .boldSystemFont(ofSize: 22)
        symbolLabel.numberOfLines = 1
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 1
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stockImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: stockImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setUpFavouriteButton() {
        containerView.addSubview(favouriteButton)
    }
    
    private func setUpStockInfo() {
        
        let changeStackView = UIStackView(arrangedSubviews: [
            changeLabel, changePercentLabel
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            priceLabel, changeStackView
        ])
        
        containerView.addSubview(stackView)
        
        priceLabel.font = .boldSystemFont(ofSize: 22)
        changeLabel.font = .boldSystemFont(ofSize: 14)
        changePercentLabel.font = .boldSystemFont(ofSize: 14)
        
        changeStackView.axis = .horizontal
        changeStackView.spacing = 4
        changeStackView.alignment = .center
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        changePercentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func returnDirection(change: Double) -> Bool {
        if change == 0.0 {
            return true
        } else if change > 0 {
            return true
        } else {
            return false
        }
    }
    
}
