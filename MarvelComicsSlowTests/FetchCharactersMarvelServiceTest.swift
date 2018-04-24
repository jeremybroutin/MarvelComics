import XCTest
@testable import MarvelComics

class MockURLSession: URLSessionProtocol {
  // Was the dataTask creation called exactly one time?
  var dataTaskCallCount = 0
  // Verify that the url elements (eg: host) are correct.
  var dataTaskLastURL: URL?
  // Mock the dataTask to override the resume() function.
  var dataTaskReturnValue: URLSessionDataTask!

  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
    dataTaskCallCount += 1
    dataTaskLastURL = url
    return dataTaskReturnValue
  }

  func verifyDataTask(urlMatcher: ((URL?) -> Bool), file: StaticString = #file, line: UInt = #line) {
    
    /*
     This helper function leverages a predicate (urlMatcher) to check for url validity.
     It also leverages the default implementation of literal expressions file and line,
     which evaluate at the point of call.
     */

    XCTAssertEqual(dataTaskCallCount, 1, "dataTask call count failure", file: file, line: line)
    XCTAssertTrue(urlMatcher(dataTaskLastURL), "Actual url was \(String(describing: dataTaskLastURL))", file: file, line:line)
  }
}

class PartialMockURLSessionDataTask: URLSessionDataTask {

  /*
   Partial mock only because we are taking a real class and replacing ONE method.
   Code smell: mixes test code with production code in a single object.
   Necessary use because we cannot change the signature.
   */

  private var resumeCallCount = 0

  override func resume() {
    resumeCallCount += 1
  }

  func verifyResume(file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(resumeCallCount, 1, "resume call count", file: file, line: line)
  }
}

class FetchCharactersMarvelServiceTest: XCTestCase {

  var sut: FetchCharactersMarvelService!
  var mockURLSession: MockURLSession!
  var mockDataTask: PartialMockURLSessionDataTask!

  override func setUp() {
    super.setUp()
    mockDataTask = PartialMockURLSessionDataTask()
    mockURLSession = MockURLSession()
    mockURLSession.dataTaskReturnValue = mockDataTask
    sut = FetchCharactersMarvelService(session: mockURLSession, authParametersGenerator: { return "" })
  }

  override func tearDown() {
    sut = nil
    mockURLSession = nil
    mockDataTask = nil
    super.tearDown()
  }

  private func dummyRequestModel() -> FetchCharactersRequestModel {
    return FetchCharactersRequestModel(namePrefix: "DUMMY", limit: 10, offset: 30)
  }

  func testFetchCharacters_ShouldMakeDataTaskForMarvelEndpoint() {
    sut.fetchCharacters(requestModel: dummyRequestModel(), networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { (url) -> Bool in
      url?.host == "gateway.marvel.com"
    })
  }

  func testFetchCharacters_ShouldMakeDataTaskWithSecureConnection() {
    sut.fetchCharacters(requestModel: dummyRequestModel(), networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.scheme == "https" })
  }

  func testFetchCharacters_ShouldMakeDataTaskForCharactersAPI() {
    sut.fetchCharacters(requestModel: dummyRequestModel(), networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.path == "/v1/public/characters" })
  }

  func testFetchCharacters_WithNamePrefix_ShouldMakeTaskWithQueryForNameStartsWith() {
    let requestModel = FetchCharactersRequestModel(namePrefix: "NAME", limit: 10, offset: 30)
    sut.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.hasQuery(name: "nameStartsWith", value: "NAME") ?? false })
  }

  func testFetchCharacters_WithNamePrefix_ShouldHandleSpacesInNameStartsWith() {
    let requestModel = FetchCharactersRequestModel(namePrefix: "NA ME", limit: 10, offset: 30)
    sut.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.hasQuery(name: "nameStartsWith", value: "NA ME") ?? false })
  }

  func testFetchCharacters_WithOffset_ShouldMakeDataTaskWithQueryForOffset() {
    let requestModel = FetchCharactersRequestModel(namePrefix: "DUMMY", limit: 10, offset: 30)
    sut.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.hasQuery(name: "offset", value: "30") ?? false })
  }

  func testFetchCharacters_WithPageSize_ShouldMakeDataTaskWithQueryForPageSize() {
    let requestModel = FetchCharactersRequestModel(namePrefix: "DUMMY", limit: 10, offset: 30)
    sut.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.hasQuery(name: "limit", value: "10") ?? false })
  }

  func testFetchCharacters_ShouldIncludeGeneratedAuthenticationParameters() {
    let sutWithAuthParams = FetchCharactersMarvelService(session: mockURLSession, authParametersGenerator: { return "&FOO=BAR" })
    sutWithAuthParams.fetchCharacters(requestModel: dummyRequestModel(), networkRequest: NetworkRequest())
    mockURLSession.verifyDataTask(urlMatcher: { url in url?.hasQuery(name: "FOO", value: "BAR") ?? false })
  }

  func testFetchCharacters_ShouldStartDataTask() {
    sut.fetchCharacters(requestModel: dummyRequestModel(), networkRequest: NetworkRequest())
    mockDataTask.verifyResume()
  }
}
