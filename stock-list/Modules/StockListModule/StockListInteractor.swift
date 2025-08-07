import Foundation

class StockListInteractor: StockListInteractorProtocol {
    
    var repo: CoreDataRepositoryProtocol?
    var presenter: StockListPresenterProtocol?
    var apiService: APIServiceProtocol?
    
    func fetchData() {
        
        let cachedStocks = repo?.load() ?? []
        
        if cachedStocks.isEmpty == false {
            let response = StockListResponse(stocks: cachedStocks)
            self.presenter?.presentData(response: response)
        }
        
        apiService?.extractData { result in
            
            switch result {
            case .success(let stockDTOs):
                let stocks = stockDTOs.map { entity in
                    Stock(symbol: entity.symbol,
                          name: entity.name,
                          price: entity.price,
                          change: entity.change,
                          changePercent: entity.changePercent,
                          logoURL: entity.logo)
                    
                }
                self.repo?.save(stocks)
                
                let response = StockListResponse(stocks: stocks)
                self.presenter?.presentData(response: response)
                
            case .failure(let error):
                print("Ошибка извлечения данных \(error)")
            }
            
        }
        
    }
}
