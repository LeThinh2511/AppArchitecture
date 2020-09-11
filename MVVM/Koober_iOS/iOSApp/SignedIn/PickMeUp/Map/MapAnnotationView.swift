import UIKit
import KooberUIKit
import MapKit
import PromiseKit

class MapAnnotationView: MKAnnotationView {
    
    // MARK: - Properties
    let imageCache: ImageCache
    private var lastAnnotation: MapAnnotation
    
    var mapAnnotation: MapAnnotation? {
        if let a = annotation as? MapAnnotation {
            return a
        } else if annotation != nil {
            assertionFailure("Property Access Error: MapAnnotationView holds a non-nil annotation of an unsupported type. Expecting MapAnnotation, have \(type(of: annotation))")
            return nil
        } else {
            return nil
        }
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            if annotation == nil { return }
            
            guard let new = annotation as? MapAnnotation else {
                assertionFailure("Type Mismatch Error: MapAnnotationView was given an annotation of type \(type(of: annotation)) rather than expected type, MapAnnotation.")
                return
            }
            assert(lastAnnotation.imageIdentifier == new.imageIdentifier)
            lastAnnotation = new
        }
    }
    
    // MARK: - Methods
    @nonobjc
    init(annotation: MapAnnotation, reuseIdentifier: String, imageCache: ImageCache) {
        self.imageCache = imageCache
        self.lastAnnotation = annotation
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let imageName = annotation.imageName {
            self.image = UIImage(named: imageName)
        }
        
        if let imageURL = annotation.imageURL {
            let annotationIDAndType = (id: annotation.id, type: annotation.type)
            firstly {
                self.imageCache.getImage(at: imageURL)
            }.done { image in
                guard annotationIDAndType.id == self.mapAnnotation?.id
                        && annotationIDAndType.type == self.mapAnnotation?.type else {
                    return
                }
                self.image = image
            }.catch { error in
                print("Error fetching available ride image from image cache for map annotation: \(error)")
                guard annotationIDAndType.id == self.mapAnnotation?.id
                        && annotationIDAndType.type == self.mapAnnotation?.type else {
                    return
                }
                self.image = #imageLiteral(resourceName: "available_placeholder_marker")
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("MapAnnotationView does not support instantiation via NSCoding.")
    }
}
