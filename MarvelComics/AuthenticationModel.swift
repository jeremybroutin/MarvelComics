import Foundation

protocol AuthenticationModel {

  /// An API public key.
  var publicKey : String { get }
  /// An API private key.
  var privateKey: String { get }
  /// A MD5 digest (hash) of a string.
  var md5: (String) -> String { get set }

  /// Returns a string of parameters for authentication requests.
  mutating func urlParameters(timeStamp: String) -> String
}

extension AuthenticationModel {

  /// Returns a string of parameters for Marvel API authentication.
  mutating func urlParameters(timeStamp: String = Self.timeStamp()) -> String {
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
