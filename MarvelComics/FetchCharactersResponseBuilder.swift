import Foundation

struct FetchCharactersResponseBuilder {

  func parseJSONData(_ data: Data?) -> FetchCharactersResponseModel? {
    guard let data = data else { return nil }

    do {
      let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
      let code = dict["code"] as! Int
      return FetchCharactersResponseModel(code: code)
    } catch let error {
      print("json serialization error: \(error)")
      return nil
    }
  }
  
}
