import Foundation

protocol AuthenticationModel {

  var publicKey : String { get }
  var privateKey: String { get }
  var md5: (String) -> String { get set }

  mutating func urlParameters(timeStamp: String) -> String
}

extension AuthenticationModel {

  mutating func urlParameters(timeStamp: String = Self.timeStamp()) -> String {
    let hash = md5(timeStamp + publicKey + privateKey)
    return "&ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
  }

  private static func timeStamp() -> String {
    return String(Date().timeIntervalSinceReferenceDate)
  }
}
