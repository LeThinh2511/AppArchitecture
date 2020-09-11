import Foundation

public struct RemoteImage: Decodable {
    
    // MARK: - Properties
    public var at1xURL: URL
    public var at2xURL: URL
    public var at3xURL: URL
    
    // MARK: - Methods
    public init(at1xURL: URL, at2xURL: URL, at3xURL: URL) {
        self.at1xURL = at1xURL
        self.at2xURL = at2xURL
        self.at3xURL = at3xURL
    }
    
    public func url(forScreenScale scale: CGFloat) -> URL {
        switch scale {
        case 1.0:
            return at1xURL
        case 2.0:
            return at2xURL
        case 3.0:
            return at3xURL
        default:
            return at1xURL
        }
    }
}
