import Foundation

struct FetchCharactersResponseBuilder {

  var code: Int?
  var status: String?

  func parseJSONData(_ data: Data?) -> FetchCharactersResponseModel? {
    guard let data = data else { return nil }

    do {
      let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
      let code = dict["code"] as! Int
      return FetchCharactersResponseModel(code: code, status: "ok")
    } catch let error {
      print("json serialization error: \(error)")
      return nil
    }
  }

  func build() -> FetchCharactersResponseModel? {
    guard let code = code, let status = status else { return nil }
    return FetchCharactersResponseModel(code: code, status: status)
  }

}
