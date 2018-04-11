import Foundation

struct CharactersSliceResponseBuilder {
  let offset: Int?
  let total: Int?
  let results: [CharacterResponseBuilder]?

  init(dictionary: [String: Any]) {
    offset = dictionary["offset"] as? Int
    total = dictionary["total"] as? Int
    results = type(of: self).parseResults(from: dictionary["results"] as? [Any])
  }

  func build() -> CharactersSliceResponseModel? {
    guard let offset = offset, let total = total else { return nil }
    return CharactersSliceResponseModel(offset: offset, total: total, characters: buildCharacters())
  }

  // MARK: - Private

  // Use type method to be able to call it within initialization.
  private static func parseResults(from array: [Any]?) -> [CharacterResponseBuilder]? {

    /*
     parseResults loop through the "results" array and only captures the values that are
     dictionaries ([String: Any]).
     Once done these dictionaries are passed to the CharacterResponseBuilder.
     */

    return array?.compactMap { $0 as? [String: Any] }
                 .map { CharacterResponseBuilder(dictionary: $0) }
  }

  private func buildCharacters() -> [CharacterResponseModel] {

    /*
     Loops through the results which is an array of CharacterResponseBuilder, build
     each corresponding CharacterResponseModel and append it to a new array.
     If results is nil, return an empty array instead.
     */
    
    return results?.compactMap { $0.build() } ?? []
  }
}
