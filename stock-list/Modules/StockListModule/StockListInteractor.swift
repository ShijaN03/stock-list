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
                
                let cachedStocks = self.repo?.load()
                
                let stocks = stockDTOs.map { entity in
                    Stock(symbol: entity.symbol,
                          name: entity.name,
                          price: entity.price,
                          change: entity.change,
                          changePercent: entity.changePercent,
                          logoURL: entity.logo,
                          isFavourite:
                            cachedStocks?
                        .first(where: {
                            $0.symbol == entity.symbol
                        })?
                        .isFavourite ?? false
                    )
                    
                }
                self.repo?.save(stocks)
                
                let response = StockListResponse(stocks: stocks)
                self.presenter?.presentData(response: response)
                
            case .failure(let error):
                print("Ошибка извлечения данных \(error)")
            }
            
        }
        
    }
    
    func updateCoreData(with data: [StockViewModel]) {
        let stocks: [Stock] = data.map {
            Stock(symbol: $0.symbol,
                  name: $0.name,
                  price: $0.price,
                  change: $0.change,
                  changePercent: $0.changePercent,
                  logoURL: $0.logoURL,
                  isFavourite: $0.isFavourite)
        }
        
        DispatchQueue.main.async {
            self.repo?.save(stocks)
        }
        
    }
}
