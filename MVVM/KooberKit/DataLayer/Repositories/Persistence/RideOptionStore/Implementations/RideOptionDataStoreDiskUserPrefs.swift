import Foundation
import PromiseKit

public class RideOptionDataStoreDiskUserPrefs: RideOptionDataStore {
    
    // MARK: - Properties
    let accessQueue = DispatchQueue(label: "com.razeware.kooberkit.rideoptiondatastore.userprefs.access")
    var locationIDs: Set<LocationID> = []
    
    // MARK: - Methods
    public init() {}
    
    public func update(rideOptions: [RideOption], availableAt pickupLocationID: LocationID) -> Promise<[RideOption]> {
        return Promise { seal in
            self.accessQueue.async {
                let dictionaries = rideOptions.map(RideOption.asDictionary)
                UserDefaults.standard.set(dictionaries,
                                          forKey: pickupLocationID.userPreferencesKey)
                self.locationIDs.insert(pickupLocationID)
                seal.fulfill(rideOptions)
            }
        }
    }
    
    public func read(availableAt pickupLocationID: LocationID) -> Promise<[RideOption]> {
        return Promise { seal in
            self.accessQueue.async {
                let key = pickupLocationID.userPreferencesKey
                guard let dictionaries = UserDefaults.standard.array(forKey: key) as? [[String: Any]] else {
                    seal.fulfill([])
                    return
                }
                let rideOptions = dictionaries.map(RideOption.make(withEncodedDictionary:))
                seal.fulfill(rideOptions)
            }
        }
    }
    
    public func flush() {
        self.accessQueue.async {
            self.locationIDs.forEach(self.flush(availableAt:))
            self.locationIDs.removeAll()
        }
    }
    
    private func flush(availableAt pickupLocationID: LocationID) {
        UserDefaults.standard.removeObject(forKey: pickupLocationID.userPreferencesKey)
    }
}

private extension LocationID {
    
    var userPreferencesKey: String {
        return "ride_options_at_\(self)"
    }
}

extension RemoteImage {
    
    static func make(withEncodedDictionary dictionary: [String: String]) -> RemoteImage {
        let at1xURL = URL(string: dictionary["at1xURL"]!)!
        let at2xURL = URL(string: dictionary["at2xURL"]!)!
        let at3xURL = URL(string: dictionary["at3xURL"]!)!
        return RemoteImage(at1xURL: at1xURL, at2xURL: at2xURL, at3xURL: at3xURL)
    }
    
    func asDictionary() -> [String: String] {
        return ["at1xURL" : at1xURL.absoluteString,
                "at2xURL" : at2xURL.absoluteString,
                "at3xURL" : at3xURL.absoluteString]
    }
}

extension RideOption {
    
    static func make(withEncodedDictionary dictionary: [String: Any]) -> RideOption {
        let id = dictionary["id"]! as! String
        let name = dictionary["name"]! as! String
        let buttonRemoteImages = (RemoteImage.make(withEncodedDictionary: dictionary["buttonSelectedRemoteImage"] as! [String: String]), RemoteImage.make(withEncodedDictionary: dictionary["buttonRemoteImage"] as! [String: String]))
        let availableMapMarkerRemoteImage = RemoteImage.make(withEncodedDictionary: dictionary["availableMapMarkerRemoteImage"] as! [String: String])
        return RideOption(id: id,
                          name: name,
                          buttonRemoteImages: buttonRemoteImages,
                          availableMapMarkerRemoteImage: availableMapMarkerRemoteImage)
    }
    
    func asDictionary() -> [String: Any] {
        return ["id": id,
                "name": name,
                "buttonRemoteImage": buttonRemoteImages.unselected.asDictionary(),
                "buttonSelectedRemoteImage": buttonRemoteImages.selected.asDictionary(),
                "availableMapMarkerRemoteImage": availableMapMarkerRemoteImage.asDictionary()]
        
    }
}
