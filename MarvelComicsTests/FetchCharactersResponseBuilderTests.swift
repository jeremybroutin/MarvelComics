import XCTest
@testable import MarvelComics

class FetchCharactersResponseBuilderTests: XCTestCase {

  func testInit_WithNonDictionaryData_ShouldCaptureNilInBuilder() {
    let dict: [String: Any] = ["data": 123]
    let sut = FetchCharactersResponseBuilder(dictionary: dict)
    XCTAssertNil(sut.data)
  }

  func testInit_WithData_ShouldCaptureValueInBuilder() {
    let dict: [String: Any] = ["data": ["offset":123]]
    let sut = FetchCharactersResponseBuilder(dictionary: dict)
    XCTAssertEqual(sut.data?.offset, 123)
  }

  func testBuild_WithDataWithRequiredFields_ShouldYieldSuccessWithSlice() {
    let dict: [String: Any] = ["data": [
      "offset": 123,
      "total": 5,
      ],
    ]
    let sut = FetchCharactersResponseBuilder(dictionary: dict)
    let response = sut.build()

    switch response {
    case .success(let slice):
      XCTAssertEqual(slice.offset, 123)
      XCTAssertEqual(slice.total, 5)
    default:
      XCTFail("Expected success, got \(response)")
    }

    /*
     We are not evaluating the failure case here and instead call XCTFail if we get
     anything else than success.
     */
  }

  func testBuild_WithoutData_ShouldYieldFailure() {
    let dict: [String: Any] = [:]
    let sut = FetchCharactersResponseBuilder(dictionary: dict)
    let response = sut.build()

    switch response {
    case .failure(let error):
      XCTAssertEqual(error, "Invalid data")
    default:
      XCTFail("Expected failure, got \(response)")
    }

    /*
     Same as previous test for build success, we only evaluate the failure case
     and call XCTFail for any other case.
     */
  }


}
