import Foundation
import KooberUIKit
import PromiseKit
import KooberKit

class RideOptionSegmentButtonImageLoader {
    
    // MARK: - Properties
    let imageCache: ImageCache
    
    // MARK: - Methods
    init(imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
    func loadImages(using segments: [RideOptionSegmentViewModel]) -> Promise<[RideOptionSegmentViewModel]> {
        let promises = segments.map { (segment) -> Promise<RideOptionSegmentViewModel> in
            guard case let .notLoaded(normalURL, selectedURL) = segment.images else {
                return .value(segment)
            }
            return imageCache.getImagePair(at: normalURL, and: selectedURL).map { imagePair in
                var s = segment
                s.images = .loaded(normalURL: normalURL, normalImage: imagePair.image1,
                                   selectedURL: selectedURL, selectedImage: imagePair.image2)
                return s
            }
        }
        return when(fulfilled: promises)
    }
}
