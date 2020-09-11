import UIKit
import KooberKit

class RideOptionButton: UIButton {
    
    // MARK: - Properties
    var nameLabel: UILabel = UILabel()
    let id: String
    
    var didSelectRideOption: ((String) -> ())?
    
    // MARK: - Methods
    init(segment: RideOptionSegmentViewModel) {
        self.id = segment.id
        super.init(frame: .zero)
        
        self.bounds = CGRect(x: 0, y: 0, width: 78, height: 110)
        self.isSelected = segment.isSelected
        
        guard case let .loaded(_, normalImage, _, selectedImage) = segment.images else {
            let normalImage = #imageLiteral(resourceName: "ride_option_placeholder")
            let selectedImage = #imageLiteral(resourceName: "ride_option_placeholder_selected")
            set(image: normalImage, selectedImage: selectedImage, title: segment.title)
            return
        }
        
        set(image: normalImage, selectedImage: selectedImage, title: segment.title)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("RideOptionButton does not support initialization via NSCoding.")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        addSubview(nameLabel)
        addTarget(self,
                  action: #selector(RideOptionButton.tapped(button:)),
                  for: .touchUpInside)
    }
    
    @objc
    func tapped(button: UIButton) {
        didSelectRideOption?(id)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.height
        let width = bounds.width
        let labelHeight = CGFloat(20.0)
        
        nameLabel.bounds = CGRect(x: 0, y: 80, width: width, height: labelHeight)
        nameLabel.center = CGPoint(x: width / 2.0, y: CGFloat(height - labelHeight))
    }
    
    private func set(image anImage: UIImage, selectedImage: UIImage, title: String) {
        setImage(anImage, for: .normal)
        setImage(selectedImage, for: .selected)
        imageView?.contentMode = .center
        nameLabel.text = title
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 15.0)
    }
}
