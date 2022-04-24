

import UIKit
import Elements

class ImageCollectionViewCell: UICollectionViewCell {

    private let imageView : BaseUIImageView = {
        let imageView = BaseUIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with urlString : String){
        guard let url = URL(string: urlString) else{ return }
        URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else{
                print("Error: Configure")
                return }
            DispatchQueue.main.async{
                let image = UIImage(data: data)
                self?.imageView.image = image
                print("Succeed")
            }
        }.resume()
    }

    
}
