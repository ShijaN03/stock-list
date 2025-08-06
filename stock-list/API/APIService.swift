import Foundation

protocol APIServiceProtocol: AnyObject {
    func fetchData(completion: @escaping (Result<[StockDTO], Error>) -> Void)
}

final class StockAPIService: APIServiceProtocol {
    
    func fetchData(completion: @escaping (Result<[StockDTO], any Error>) -> Void) {
        
        guard let url = URL(string: "https://mustdev.ru/api/stocks.json") else {
            return completion(.failure(APIErrors.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data else {
                return completion(.failure(APIErrors.noData))
            }
            
            do {
                let stocks = try JSONDecoder().decode([StockDTO].self, from: data)
                completion(.success(stocks))
            } catch {
                return(completion(.failure(APIErrors.dataExtractError)))
            }
            
        }.resume()
    }
    
    
}
