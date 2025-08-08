import UIKit

extension UIImageView {
    
    func load(with url: URL) {
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
