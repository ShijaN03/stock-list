import Foundation

struct StockDTO: Decodable {
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let logoURL: URL
}
