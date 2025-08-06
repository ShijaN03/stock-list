import UIKit

final class StockListBuilder {
    static func build() -> UIViewController {
        
        let view = StockListView()
        let interactor = StockListInteractor()
        let presenter = StockListPresenter()
        let router = StockListRouter()
        
        view.interactor = interactor
        view.router = router
        
        interactor.presenter = presenter
        
        presenter.view = view
        
        router.view = view
        
        return view
    }
}
