import Foundation
import KooberKit

enum MapAnnotationType: String {
    
    case pickupLocation
    case dropoffLocation
    case availableRide
    
    static func makePickupLocationAnnotation(`for` location: Location) -> MapAnnotation {
        return MapAnnotation(id: location.id,
                             latitude: location.latitude,
                             longitude: location.longitude,
                             type: .pickupLocation,
                             imageName: "MapMarkerPickupLocation")
    }
    
    static func makeDropoffLocationAnnotation(`for` location: Location?) -> MapAnnotation? {
        guard let location = location else { return nil }
        return MapAnnotation(id: location.id,
                             latitude: location.latitude,
                             longitude: location.longitude,
                             type: .dropoffLocation,
                             imageName: "MapMarkerDropoffLocation")
    }
}
