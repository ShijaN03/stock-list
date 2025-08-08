protocol StockListViewProtocol: AnyObject {
    func displayData(viewModel: [StockViewModel])
}

protocol StockListInteractorProtocol: AnyObject {
    func fetchData()
    func updateCoreData(with data: [StockViewModel])
}

protocol StockListPresenterProtocol: AnyObject {
    func presentData(response: StockListResponse)
}

protocol StockListRouterProtocol: AnyObject {
    
}

protocol APIServiceProtocol: AnyObject {
    func extractData(completion: @escaping (Result<[StockDTO], Error>) -> Void)
}

