import Foundation

public struct RideOptionPickerRideOptions: Equatable {
    
    // MARK: - Properties
    public internal(set) var rideOptions: [RideOption]
    public internal(set) var selectedRideOptionID: RideOptionID
    
    // MARK: - Methods
    public init(rideOptions: [RideOption], selectedRideOptionID: RideOptionID? = nil) {
        self.rideOptions = rideOptions
        if let selectedRideOptionID = selectedRideOptionID {
            self.selectedRideOptionID = selectedRideOptionID
        } else if let selectedRideOptionID = rideOptions.first?.id  {
            self.selectedRideOptionID = selectedRideOptionID
        } else {
            fatalError("Encountered empty array of ride options.")
        }
    }
}
