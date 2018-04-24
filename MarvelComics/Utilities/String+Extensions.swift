import Foundation

extension String {

  /// Returns a MD5 digest (hash) of the original string in String format.
  public func MD5Digest() -> String {
    var md5Digest = ""
    let md5Data = self.MD5()
    for (_, byte) in md5Data.enumerated() {
      md5Digest += String(format: "%02x", byte)
    }
    return md5Digest
  }

  /// Returns a MD5 hash of the original string in Data format.
  private func MD5() -> Data {

    /* MD5 hashing as per
     https://stackoverflow.com/questions/32163848/how-to-convert-string-to-md5-hash-using-ios-swift
     */

    // Convert String to Data
    let messageData = self.data(using: .utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    // Hash string data using CC_MD5
    _ = digestData.withUnsafeMutableBytes{ digestBytes in
      messageData.withUnsafeBytes { messageBytes in
        CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
      }
    }
    return digestData
  }
}
