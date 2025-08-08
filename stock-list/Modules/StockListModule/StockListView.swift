import UIKit
import Foundation

class StockListView: UIViewController {
    
    var interactor: StockListInteractorProtocol?
    var router: StockListRouterProtocol?
    
    var viewModel: [StockViewModel] = []
    private var filtredViewModel: [StockViewModel] = []
    
    private var isSearching = false
    
    private let headView = UIView()
    private let searchBar = UISearchBar()
    private let stocksButton = UIButton()
    private let favouritesButton = UIButton()
    private let tableView = UITableView()
    
    private var headViewTopConstraint: NSLayoutConstraint?
    
    @objc func stockButtonTapped() {
        stocksButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        favouritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        filtredViewModel = viewModel
        tableView.reloadData()
    }
    
    @objc func favouritesButtonTapped() {
        stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        favouritesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        filtredViewModel.removeAll()
        for stock in viewModel {
            if stock.isFavourite == true {
                filtredViewModel.append(stock)
            }
        }
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxOffset: CGFloat = 50
        let newConstant = max(-offsetY, -maxOffset)
        
        let alpha = 1 - min(max(offsetY / maxOffset, 0), 1)
        
        searchBar.alpha = alpha
        headViewTopConstraint?.constant = newConstant
        
        view.layoutIfNeeded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.fetchData()
        
        view.backgroundColor = .white
        setUpUI()
    }
    
    func displayData(viewModel: [StockViewModel]) {
        self.viewModel = viewModel
        self.filtredViewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setUpUI() {
        stocksButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        setUpHeadView()
        setUpTableView()
    }
    
    private func setUpHeadView() {
        
        view.addSubview(headView)
        
        let stackView = UIStackView(arrangedSubviews: [
            stocksButton, favouritesButton
        ])
        
        headView.addSubview(stackView)
        headView.addSubview(searchBar)
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        stocksButton.setTitle("Stocks", for: .normal)
        favouritesButton.setTitle("Favourites", for: .normal)
        
        stocksButton.setTitleColor(.white, for: .normal)
        favouritesButton.setTitleColor(.white, for: .normal)
        
        stocksButton.addTarget(self, action: #selector(stockButtonTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .clear
        
        searchBar.placeholder = "Search company or ticker"
        searchBar.searchTextField.backgroundColor = .white
        
        searchBar.searchTextField.layer.borderWidth = 1
        
        searchBar.clipsToBounds = true
        
        headView.backgroundColor = .black
        searchBar.backgroundColor = .black
        
        headView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        headViewTopConstraint = headView.topAnchor.constraint(equalTo: view.topAnchor)
        headViewTopConstraint?.isActive = true
        
        
        NSLayoutConstraint.activate([
            headView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headView.heightAnchor.constraint(equalToConstant: 170),
            
            searchBar.leadingAnchor.constraint(equalTo: headView.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: headView.trailingAnchor, constant: -20),
            searchBar.bottomAnchor.constraint(equalTo: headView.bottomAnchor, constant: -50),
            
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: -10),
            stackView.centerXAnchor.constraint(equalTo: headView.centerXAnchor)
        ])
    }
    
    private func setUpTableView() {
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.register(StockListCell.self, forCellReuseIdentifier: StockListCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension StockListView: StockListViewProtocol {
    
}

extension StockListView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filtredViewModel = viewModel
        } else {
            filtredViewModel = viewModel.filter {
                $0.name.lowercased().hasPrefix(searchText.lowercased()) ||
                $0.symbol.lowercased().hasPrefix(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filtredViewModel = viewModel
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension StockListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.identifier, for: indexPath) as? StockListCell else { return UITableViewCell() }
        
        cell.favouriteButtonTapped = { [weak self] in
            
            guard let self = self else { return }
            
            let stock = self.filtredViewModel[indexPath.row]
            
            if let index = self.viewModel.firstIndex(where: { $0.symbol == stock.symbol
            }) {
                self.viewModel[index].isFavourite.toggle()
                self.filtredViewModel[indexPath.row].isFavourite = self.viewModel[index].isFavourite
            }
            print(self.viewModel[indexPath.row].isFavourite)
            self.interactor?.updateCoreData(with: self.viewModel)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.configure(with: filtredViewModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
