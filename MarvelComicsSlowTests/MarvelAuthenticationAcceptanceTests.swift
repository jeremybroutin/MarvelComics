import XCTest
@testable import MarvelComics

class MarvelAuthenticationAcceptanceTests: XCTestCase {

  func testValidCallToMarvel_ShouldGetHTTPStatusCode200() {
    let queryWithoutAuth = "https://gateway.marvel.com/v1/public/characters?nameStartsWith=Spider"
    let fullQuery = queryWithoutAuth + MarvelAuthentication().urlParameters()
    guard let validQueryURL = URL(string: fullQuery) else {
      XCTFail("Invalid URL: \(fullQuery)")
      return
    }

    var httpResponse: HTTPURLResponse?
    var responseError: Error?
    let promise = expectation(description: "Completion handler invoked")

    startDataTask(with: validQueryURL) { (data, response, error) in
      httpResponse = response as? HTTPURLResponse
      responseError = error
      promise.fulfill()
    }

    self.waitForExpectations(timeout: 5, handler: nil)

    XCTAssertNil(responseError)
    XCTAssertEqual(httpResponse?.statusCode, 200)
  }

  func startDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let session = URLSession.shared
    let dataTask = session.dataTask(with: url) { (data, response, error) in
      completionHandler(data, response, error)
    }
    dataTask.resume()
  }

}
