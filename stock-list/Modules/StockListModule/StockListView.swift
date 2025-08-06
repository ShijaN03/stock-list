import UIKit

class StockListView: UIViewController {
    
    var interactor: StockListInteractorProtocol?
    var router: StockListRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension StockListView: StockListViewProtocol {
    
}
