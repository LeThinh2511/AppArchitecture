import UIKit
import PromiseKit

public class InBundleImageCache: ImageCache {

  // MARK: - Methods
  public init() {}

  public func getImage(at url: URL) -> Promise<UIImage> {
    let imageFilename = self.imageFilename(from: url)
    return .value(UIImage(named: imageFilename,
                                  in: Bundle(for: InBundleImageCache.self),
                                  compatibleWith: nil)!)
  }

  public func getImagePair(at url1: URL, and url2: URL) -> Promise<(image1: UIImage, image2: UIImage)> {
    let imageFilename1 = imageFilename(from: url1)
    let imageFilename2 = imageFilename(from: url2)
    return .value((UIImage(named: imageFilename1)!, UIImage(named: imageFilename2)!) )
  }

  func imageFilename(from url: URL) -> String {
    var imageFilename = url.lastPathComponent
    imageFilename = imageFilename.replacingOccurrences(of: "@2x", with: "")
    imageFilename = imageFilename.replacingOccurrences(of: "@3x", with: "")
    return imageFilename
  }
}
