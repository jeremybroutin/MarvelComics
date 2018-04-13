import XCTest
@testable import MarvelComics

class NetworkRequestTests: XCTestCase {

  var sut: NetworkRequest!
  var mockURLSessionTask: MockURLSessionTask!
  var preconditionFailed = false

  override func setUp() {
    super.setUp()
    sut = NetworkRequest()
    mockURLSessionTask = MockURLSessionTask()
    
  }

  override func tearDown() {
    sut = nil
    mockURLSessionTask = nil
    super.tearDown()
  }

  func testStart_ShouldTellTaskToResume() {
    sut.start(mockURLSessionTask)
    mockURLSessionTask.verifyResume()
  }

  func testStart_ShouldRetainGivenTask() {
    sut.start(mockURLSessionTask)
    XCTAssertTrue(sut.currentTask! === mockURLSessionTask)
  }

//  func testStart_WithExistingTask_ShouldFailPrecondition() {
//    sut.start(mockURLSessionTask)
//    sut.start(mockURLSessionTask)
//    XCTAssertTrue(preconditionFailed, "Expected precondition failure")
//  }

  func testCancel_WithExistingTask_ShouldTellTaskToCancel() {
    sut.start(mockURLSessionTask)
    sut.cancel()
    mockURLSessionTask.verifyCancel()
  }

}

class MockURLSessionTask: URLSessionTaskProtocol {
  private var resumeCallCount = 0
  private var cancelCount = 0

  func resume() {
    resumeCallCount += 1
  }

  func cancel() {
    cancelCount += 1
  }

  func verifyResume(file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(resumeCallCount, 1, "resume call count", file: file, line: line)
  }

  func verifyCancel(file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(cancelCount, 1, "cancel call count", file: file, line: line)
  }
}
