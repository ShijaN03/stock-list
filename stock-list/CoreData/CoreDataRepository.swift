import CoreData

protocol CoreDataRepositoryProtocol: AnyObject {
    func save(_ stocks: [Stock])
    func load() -> [Stock]
}

final class CoreDataStockRepository: CoreDataRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func save(_ stocks: [Stock]) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CoreDataStock.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("\(error)")
        }
        
        for stock in stocks {
            let entity = CoreDataStock(context: context)
            entity.change = stock.change
            entity.changePercent = stock.changePercent
            entity.logoURL = stock.logoURL
            entity.name = stock.name
            entity.price = stock.price
            entity.symbol = stock.symbol
            entity.isFavourite = stock.isFavourite
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    
    func load() -> [Stock] {
        let request: NSFetchRequest<CoreDataStock> = CoreDataStock.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map {
                Stock(symbol: $0.symbol ?? "",
                      name: $0.name ?? "",
                      price: $0.price,
                      change: $0.change,
                      changePercent: $0.changePercent,
                      logoURL: $0.logoURL ?? "",
                      isFavourite: $0.isFavourite)
            }
        } catch {
            print("\(error)")
            return []
        }
    }
}

