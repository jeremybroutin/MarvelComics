import XCTest
@testable import MarvelComics

class CharactersSliceResponseBuilderTest: XCTestCase {
    
  func testInit_WithTwoResults_ShouldCaptureTwoCharactersInBuilder() {
    let dict: [String: Any] = ["results": [
      ["name": "ONE"],
      ["name": "TWO"],
      ]]
    let sut = CharactersSliceResponseBuilder(dictionary: dict)
    XCTAssertEqual(sut.results?.count, 2)
    XCTAssertEqual(sut.results?[0].name, "ONE")
    XCTAssertEqual(sut.results?[1].name, "TWO")
  }

  func testInit_WithNonArrayResult_ShouldCaptureNilInBuilder() {
    let dict: [String: Any] = ["results": ["name": "DUMMY"]]
    let sut = CharactersSliceResponseBuilder(dictionary: dict)
    XCTAssertNil(sut.results)
  }

  func testInit_WithTwoResultsButFirstNotDictionary_ShouldCaptureValidSecondResult() {
    let dict: [String: Any] = ["results": [
      "DUMMY",
      ["name": "TWO"],
      ]]
    let sut = CharactersSliceResponseBuilder(dictionary: dict)
    XCTAssertEqual(sut.results?.count, 1)
    XCTAssertEqual(sut.results?[0].name, "TWO")
  }

  func testBuild_WithRequiredFieldsButNoResults_ShouldHaveEmptyCharactersArray() {
    let dict = addRequiredFields(to: [:])
    let sut = CharactersSliceResponseBuilder(dictionary: dict)
    let response = sut.build()
    XCTAssertEqual(response?.characters.count, 0)
  }

  // MARK: - Helpers

  func addRequiredFields(to dict: [String: Any]) -> [String: Any] {
    var newDict = dict
    newDict["offset"] = 0
    newDict["total"] = 0
    return newDict
  }
    
}
