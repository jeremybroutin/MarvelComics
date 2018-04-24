import Foundation

struct FetchCharactersParser {

  private static let badJSON = "Bad JSON"

  static func parse(jsonData: Data) -> FetchCharactersResponseModel {
    let object = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    guard let dict = object as? [String: Any],
      let code = dict["code"] as? Int else {
        return .failure(badJSON)
    }
    if code != 200 {
      return .failure(dict["status"] as? String ?? badJSON)
    }
    let builder = FetchCharactersResponseBuilder(dictionary: dict)
    return builder.build()
  }

}
