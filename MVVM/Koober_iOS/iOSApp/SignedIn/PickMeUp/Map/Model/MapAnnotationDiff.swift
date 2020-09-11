import Foundation

typealias MapAnnotationDiff = (annotationsToRemove: [MapAnnotation], annotationsToAdd: [MapAnnotation])

class MapAnnotionDiff {
    
    // MARK: - Methods
    static func diff(currentAnnotations: [MapAnnotation], updatedAnnotations: [MapAnnotation]) -> MapAnnotationDiff {
        let current = Set(currentAnnotations)
        let updated = Set(updatedAnnotations)
        
        let annotationsToRemove = Array(current.subtracting(updated))
        let annotationsToAdd = Array(updated.subtracting(current))
        
        return (annotationsToAdd: annotationsToAdd, annotationsToRemove: annotationsToRemove)
    }
}
