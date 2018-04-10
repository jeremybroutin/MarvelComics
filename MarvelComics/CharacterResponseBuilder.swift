struct CharacterResponseBuilder {
  let name: String?

  init(dictionary: [String: Any]) {
    name = dictionary["name"] as? String
  }

  func build() -> CharacterResponseModel? {
    guard let name = name else { return nil }
    return CharacterResponseModel(name: name)
  }
}
