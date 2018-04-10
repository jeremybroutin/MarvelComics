import XCTest
@testable import MarvelComics

class FetchCharactersResponseBuilderTests: XCTestCase {

  var sut: FetchCharactersResponseBuilder!

  override func setUp() {
    super.setUp()
    sut = FetchCharactersResponseBuilder()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testParseJSONData_WithCode200() {
    // Given or arrange or assemble
    let json: String = "{\"code\":200}"
    let jsonData = json.data(using: .utf8, allowLossyConversion: true)

    // When or act or activate
    let response: FetchCharactersResponseModel? = sut.parseJSONData(jsonData)

    // Then or assert
    XCTAssertEqual(response?.code, 200)
  }

  func testParseJSONData_WithCode409() {
    let json: String = "{\"code\":409}"
    let jsonData = json.data(using: .utf8, allowLossyConversion: true)

    let response: FetchCharactersResponseModel? = sut.parseJSONData(jsonData)

    XCTAssertEqual(response?.code, 409)
  }

}
