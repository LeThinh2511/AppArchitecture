import UIKit

public struct RideOptionSegmentViewModel: Equatable {
    
    // MARK: - Properties
    public var id: String
    public var title: String
    public var isSelected: Bool
    public var images: ButtonRemoteImages
    
    // MARK: - Methods
    public init(id: String,
                title: String,
                isSelected: Bool,
                images: ButtonRemoteImages) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
        self.images = images
    }
    
    public static func ==(lhs: RideOptionSegmentViewModel, rhs: RideOptionSegmentViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public enum ButtonRemoteImages {
        case notLoaded(normal: URL, selected: URL)
        case loaded(normalURL: URL, normalImage: UIImage, selectedURL: URL, selectedImage: UIImage)
    }
}
