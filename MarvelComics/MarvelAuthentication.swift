import Foundation

enum MarvelKeys: String {
  case publicKey = "552c2e374cafa48d7280a7712375b987"
  case privateKey = "e6e2804f693eb24dac2c2c4a9f8f56b9430bd699"
}

struct MarvelAuthentication: AuthenticationModel {

  var publicKey = MarvelKeys.publicKey.rawValue
  var privateKey = MarvelKeys.privateKey.rawValue

  var md5: (String) -> String = { str in
    return str.MD5Digest()
  }
}
