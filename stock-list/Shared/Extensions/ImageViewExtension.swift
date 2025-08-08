import UIKit
import Kingfisher

extension UIImageView {
    
    func load(with url: URL) {
        DispatchQueue.main.async {
            self.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        
    }
}
