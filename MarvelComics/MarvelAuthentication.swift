import Foundation

struct MarvelAuthentication {

  enum MarvelKeys: String {
    case publicKey = "552c2e374cafa48d7280a7712375b987"
    case privateKey = "e6e2804f693eb24dac2c2c4a9f8f56b9430bd699"
  }

  var publicKey: String = MarvelKeys.publicKey.rawValue
  var privateKey: String = MarvelKeys.privateKey.rawValue

  lazy var md5: (String) -> String = { str in
    return str.MD5Digest()
  }

  /// Returns a string of parameters for Marvel API authentication.
  mutating func urlParameters(timeStamp: String = MarvelAuthentication.timeStamp()) -> String {
    let hash = md5(timeStamp + publicKey + privateKey)
    return "&ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
  }

  /// Returns a string representing a new timeStamp.
  private static func timeStamp() -> String {
    /* timeStamp() requires to be a value type to be passed in urlParameters
     so we set it as a static type. */
    return String(Date().timeIntervalSinceReferenceDate)
  }
}
