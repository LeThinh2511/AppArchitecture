import Foundation

public class RideOptionSegmentsFactory {
    
    // MARK: - Properties
    let rideOptions: [RideOption]
    let selectedRideOptionID: RideOptionID
    
    // MARK: - Methods
    public init(state: RideOptionPickerRideOptions) {
        self.rideOptions = state.rideOptions
        self.selectedRideOptionID = state.selectedRideOptionID
    }
    
    public func makeSegments(screenScale: CGFloat) -> [RideOptionSegmentViewModel] {
        return rideOptions.map(makeSegment(screenScale: screenScale))
    }
    
    private func makeSegment(screenScale: CGFloat) -> (RideOption) -> RideOptionSegmentViewModel {
        return { (rideOption: RideOption) -> RideOptionSegmentViewModel in
            return self.makeSegment(fromRideOption: rideOption, screenScale: screenScale)
        }
    }
    
    private func makeSegment(fromRideOption rideOption: RideOption, screenScale: CGFloat) -> RideOptionSegmentViewModel {
        let placeholderNormalImageURL = rideOption
            .buttonRemoteImages
            .unselected
            .url(forScreenScale: screenScale)
        let placeholderSelectedImageURL = rideOption
            .buttonRemoteImages
            .selected
            .url(forScreenScale: screenScale)
        return RideOptionSegmentViewModel(id: rideOption.id,
                                          title: rideOption.name,
                                          isSelected: rideOption.id == selectedRideOptionID,
                                          images: .notLoaded(normal: placeholderNormalImageURL,
                                                             selected: placeholderSelectedImageURL))
    }
}
