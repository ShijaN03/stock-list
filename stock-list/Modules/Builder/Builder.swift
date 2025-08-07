import UIKit

final class StockListBuilder {
    static func build() -> UIViewController {
        
        let repo = CoreDataStockRepository(context: CoreDataManager.shared.context)
        let apiService = StockAPIService()
        let view = StockListView()
        let interactor = StockListInteractor()
        let presenter = StockListPresenter()
        let router = StockListRouter()
        
        view.interactor = interactor
        view.router = router
        
        interactor.repo = repo
        interactor.presenter = presenter
        interactor.apiService = apiService
        
        presenter.view = view
        
        router.view = view
        
        return view
    }
}
