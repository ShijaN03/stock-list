
import Foundation
import CoreData


extension CoreDataStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataStock> {
        return NSFetchRequest<CoreDataStock>(entityName: "CoreDataStock")
    }

    @NSManaged public var change: Double
    @NSManaged public var changePercent: Double
    @NSManaged public var logoURL: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var symbol: String?

}

extension CoreDataStock : Identifiable {

}
