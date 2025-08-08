import UIKit
import Foundation

class StockListView: UIViewController {
    
    var interactor: StockListInteractorProtocol?
    var router: StockListRouterProtocol?
    
    var viewModel: [StockViewModel] = []
    private var filtredViewModel: [StockViewModel] = []
    private var isSearching = false
    
    private let headView = UIView()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
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
        setUpHeadView()
        setUpTableView()
    }
    
    private func setUpHeadView() {
        
        view.addSubview(headView)
        
        headView.addSubview(searchBar)
        
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .clear
        
        searchBar.placeholder = "Search company or ticker"
        searchBar.searchTextField.backgroundColor = .white
        
        searchBar.searchTextField.layer.borderWidth = 1
        
        searchBar.clipsToBounds = true
        
        headView.backgroundColor = .black
        searchBar.backgroundColor = .black
        
        headView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headView.topAnchor.constraint(equalTo: view.topAnchor),
            headView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headView.heightAnchor.constraint(equalToConstant: 150),
            
            searchBar.leadingAnchor.constraint(equalTo: headView.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: headView.trailingAnchor, constant: -20),
            searchBar.bottomAnchor.constraint(equalTo: headView.bottomAnchor, constant: -10)
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
        cell.configure(with: filtredViewModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
