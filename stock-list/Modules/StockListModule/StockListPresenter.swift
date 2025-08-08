class StockListPresenter: StockListPresenterProtocol {
    
    weak var view: StockListViewProtocol?

    func presentData(response: StockListResponse) {
        
        let stocks = response.stocks.map { entity in
            StockViewModel(symbol: entity.symbol,
                           name: entity.name,
                           price: entity.price,
                           change: entity.change,
                           changePercent: entity.changePercent,
                           logoURL: entity.logoURL,
                           isFavourite: entity.isFavourite)
            
        }
        
        self.view?.displayData(viewModel: stocks)
    }
    
}
