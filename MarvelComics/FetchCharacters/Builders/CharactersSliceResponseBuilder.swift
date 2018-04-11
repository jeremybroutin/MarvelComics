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
    return CharactersSliceResponseModel(offset: offset, total: total, results: buildCharacters())
  }

  // MARK: - Private

  // Use type method to be able to call it within initialization.
  private static func parseResults(from array: [Any]?) -> [CharacterResponseBuilder]? {
    return array?.compactMap { $0 as? [String: Any] }
      .map { CharacterResponseBuilder(dictionary: $0) }
  }

  private func buildCharacters() -> [CharacterResponseModel] {
    return results?.compactMap { $0.build() } ?? []
  }
}
