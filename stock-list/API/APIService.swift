import Foundation

final class StockAPIService: APIServiceProtocol {
    
    func extractData(completion: @escaping (Result<[StockDTO], any Error>) -> Void) {
        
        guard let url = URL(string: "https://mustdev.ru/api/stocks.json") else {
            return completion(.failure(APIErrors.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIErrors.noData))
                return
            }
            
            do {
                let stocks = try JSONDecoder().decode([StockDTO].self, from: data)
                completion(.success(stocks))
                return
            } catch {
                completion(.failure(APIErrors.dataExtractError))
                return
            }
            
        }.resume()
    }
    
    
}
