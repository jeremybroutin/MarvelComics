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
    sut = FetchCharactersMarvelService(session: mockURLSession)
  }

  override func tearDown() {
    sut = nil
    mockURLSession = nil
    mockDataTask = nil
    super.tearDown()
  }

  private func dummyRequestModel() -> FetchCharactersRequestModel {
    return FetchCharactersRequestModel(namePrefix: "DUMMY", pageSize: 10, offset: 30)
  }

  func testFetchCharacter_ShouldMakeDataTaskForMarvelEndpoint() {
    sut.fetchCharacters(requestModel: dummyRequestModel())
    mockURLSession.verifyDataTask(urlMatcher: { (url) -> Bool in
      url?.host == "gateway.marvel.com"
    })

  }

  func testFetchCharacter_ShouldStartDataTask() {
    sut.fetchCharacters(requestModel: dummyRequestModel())
    mockDataTask.verifyResume()
  }
}
