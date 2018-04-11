import Foundation

struct FetchCharactersResponseBuilder {

  let data: CharactersSliceResponseBuilder?

  init(dictionary: [String: Any]) {
    let dataDict = dictionary["data"] as? [String: Any]
    data = dataDict.map { CharactersSliceResponseBuilder(dictionary: $0) }
  }

  func build() -> FetchCharactersResponseModel {
    return data?.build()
                .flatMap { .success($0) } ?? .failure("Invalid data")
  }

  /*
   This implementation replaces the previous parseJSONData method buy delegating
   the parsing to builders and models structures, following the Construction Builder pattern.
   */

}
