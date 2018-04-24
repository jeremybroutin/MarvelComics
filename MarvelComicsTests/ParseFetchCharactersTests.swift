import XCTest
@testable import MarvelComics

class ParseFetchCharactersTests: XCTestCase {

  var sut: ParseFetchCharacters!

  override func setUp() {
    sut = ParseFetchCharacters()
  }

  override func tearDown() {
    sut = nil
  }

  private func jsonData(_ json: String) -> Data {
    return json.data(using: .utf8, allowLossyConversion: false)!
  }
    
  func testParse_WithCode409AndStatus_ShouldReturnFailureWithStatus() {
    let json = "{" +
               "\"code\":409," +
               "\"status\":\"STATUS\"" +
               "}"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))

    switch response {
    case let .failure(status):
      XCTAssertEqual(status, "STATUS")
    default:
      XCTFail("Expected failure, got \(response)")
    }
  }

  func testParse_WithMalformedJSON_ShouldReturnBadJSONFailure() {
    let json = "{" + "\"cod"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))
    switch response {
    case let .failure(status):
      XCTAssertEqual(status, "Bad JSON")
    default:
      XCTFail("Expected failure, got \(response)")
    }
  }

  func testParse_WithJSONArrayInsteadOfDictionary_ShouldReturnBadJSONFailure() {
    let json = "[]"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))
    switch response {
    case let .failure(status):
      XCTAssertEqual(status, "Bad JSON")
    default:
      XCTFail("Expected failure, got \(response)")
    }
  }

  func testParse_WithNonIntegerCode_ShouldReturnBadJSONFailure() {
    let json = "{" +
               "\"code\":\"409\"," +
               "\"status\":\"STATUS\"" +
               "}"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))

    switch response {
    case let .failure(status):
      XCTAssertEqual(status, "Bad JSON")
    default:
      XCTFail("Expected failure, got \(response)")
    }
  }

  func testParse_WithValidFailureCodeButNoStatus_ShouldReturnBadJSONFailure() {
    let json = "{" +
               "\"code\":409," +
               "}"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))

    switch response {
    case let .failure(status):
      XCTAssertEqual(status, "Bad JSON")
    default:
      XCTFail("Expected failure, got \(response)")
    }
  }

  func testParse_WithCode200AndRequiredData_ShouldReturnSuccessWithGivenData() {
    let json = "{" +
               "\"code\":200," +
               "\"data\":{" +
               "\"offset\":123," +
               "\"total\":456" +
               "}" +
               "}"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))
    switch response {
    case let .success(responseModel):
      XCTAssertEqual(responseModel.offset, 123)
      XCTAssertEqual(responseModel.total, 456)
    default:
      XCTFail("Expected success, got \(response)")
    }
  }

  func testParse_WithCode200ButMissingRequiredDataField_ShouldReturnFailure() {
    let json = "{" +
               "\"code\":200," +
               "\"data\":{" +
               "\"offset\":123," +
               "}" +
               "}"
    let response = sut.parseFetchCharacters(jsonData: jsonData(json))
    switch response {
    case let .failure(status):
      XCTAssertEqual(status, "Invalid data")
    default:
      XCTFail("Expected failure, got \(response)")
    }
  }
    
}
