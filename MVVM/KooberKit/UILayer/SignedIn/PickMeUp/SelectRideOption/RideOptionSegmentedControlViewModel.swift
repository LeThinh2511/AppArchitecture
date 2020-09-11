import Foundation

public struct RideOptionSegmentedControlViewModel: Equatable {
    
    // MARK: - Properties
    public var segments: [RideOptionSegmentViewModel]
    
    // MARK: - Methods
    public init(segments: [RideOptionSegmentViewModel] = []) {
        self.segments = segments
    }
    
    public static func ==(lhs: RideOptionSegmentedControlViewModel, rhs: RideOptionSegmentedControlViewModel) -> Bool {
        return lhs.segments == rhs.segments
    }
}
