import XCTest
@testable import MarvelComics

class MockURLSession: URLSessionProtocol {
  // Was the dataTask creation called exactly one time?
  var dataTaskCallCount = 0
  var dataTaskLastURL: URL?

  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
    dataTaskCallCount += 1
    dataTaskLastURL = url
    return URLSessionDataTask()
  }

  func verifyDataTask(urlMatcher: ((URL?) -> Bool), file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(dataTaskCallCount, 1, "dataTask call count failure", file: file, line: line)
    XCTAssertTrue(urlMatcher(dataTaskLastURL), "Actual url was \(String(describing: dataTaskLastURL))", file: file, line:line)

    /*
     This helper function leverages a predicate (urlMatcher) to check for url validity.
     It also leverages the default implementation of literal expressions file and line,
     which evaluates at the point of call.
     */
  }
}

class FetchCharactersMarvelServiceTest: XCTestCase {

  override func setUp() {
    super.setUp()

  }

  override func tearDown() {

    super.tearDown()
  }

  func testFetchCharacter_ShouldMakeDataTaskForMarvelEndpoint() {
    let mockURLSession = MockURLSession()
    let sut = FetchCharactersMarvelService(session: mockURLSession)
    let requestModel = FetchCharactersRequestModel(namePrefix: "DUMMY", pageSize: 10, offset: 30)

    sut.fetchCharacters(requestModel: requestModel)

    mockURLSession.verifyDataTask(urlMatcher: { (url) -> Bool in
      url?.host == "gateway.marvel.com"
    })

  }
}
