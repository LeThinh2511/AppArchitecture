import Foundation
import CoreLocation

class MapAnnotation: NSObject {
    
    // MARK: - Properties
    let id: String
    let coordinate: CLLocationCoordinate2D
    let type: MapAnnotationType
    let imageName: String?
    let imageURL: URL?
    let imageIdentifier: String
    
    // MARK: - Methods
    init(id: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, type: MapAnnotationType, imageName: String) {
        self.id = id
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.type = type
        self.imageName = imageName
        self.imageURL = nil
        self.imageIdentifier = imageName
    }
    
    init(id: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, type: MapAnnotationType, imageURL: URL) {
        self.id = id
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.type = type
        self.imageName = nil
        self.imageURL = imageURL
        self.imageIdentifier = imageURL.absoluteString
    }
}

extension MapAnnotation {
    
    override var hash: Int {
        return id.hash ^ type.rawValue.hash
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? MapAnnotation else {
            return false
        }
        
        return id == object.id && type == object.type
    }
}
