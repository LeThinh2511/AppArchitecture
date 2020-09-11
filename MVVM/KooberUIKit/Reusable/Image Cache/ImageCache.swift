import UIKit
import PromiseKit

public protocol ImageCache {
  
  func getImage(at url: URL) -> Promise<UIImage>
  func getImagePair(at url1: URL, and url2: URL) -> Promise<(image1: UIImage, image2: UIImage)>
}

enum ImageCacheError: Error {
  
  case any
}
