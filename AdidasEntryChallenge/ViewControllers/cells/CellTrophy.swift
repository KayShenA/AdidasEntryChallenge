import UIKit

enum CellStyle {
    case blue
    case gray
    
    func color() -> UIColor {
        
        switch self {
        case .blue:
            return UIColor.white.withAlphaComponent(0.2)
        case .gray:
            return UIColor.white.withAlphaComponent(0.4)
        }
    }
    
    func insets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

class CellTrophy: UICollectionViewCell {
        
    lazy var top: NSLayoutConstraint = self.background.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.background.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.background.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.background.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
    
    lazy var topImage: NSLayoutConstraint = self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
    lazy var leftImage: NSLayoutConstraint = self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5)
    lazy var bottomImage: NSLayoutConstraint = self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
    lazy var rightImage: NSLayoutConstraint = self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5)

    

    
    
    class func cellIdentify() -> String
    {
        return "cellTrophy"
    }
    
    func setCell(style: CellStyle) {
        background.backgroundColor = style.color()
        let insets = style.insets()
        top.constant = insets.top
        left.constant = insets.left
        bottom.constant = insets.bottom
        right.constant = insets.right
        
    }
    
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = nil
        contentView.addSubview(background)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([top, left, bottom, right, topImage, leftImage, bottomImage, rightImage])
        
        
    }
}
