import XCTest
@testable import MarvelComics

class HasQueryTests: XCTestCase {

  func testShouldMatchURLContainingMatchingKeyAndValueInFirstPosition() {
    let url = URL(string: "https://dummy.com/dummy?key1=value1")!
    XCTAssertTrue(url.hasQuery(name: "key1", value: "value1"))
  }

  func testShouldMatchURLContainingMatchingKeyAndValueInSecondPositon() {
    let url = URL(string: "https://dummy.com/dummy?key1=value1&key2=value2")!
    XCTAssertTrue(url.hasQuery(name: "key2", value: "value2"))
  }

  func testShouldNotMatchURLNotContainingMatchingKey() {
    let url = URL(string: "https://dummy.com/dummy?WRONGKEY=value1")!
    XCTAssertFalse(url.hasQuery(name: "key1", value: "value1"))
  }

  func testShouldNotMatchURLContainingMatchingKeyButWrongValue() {
    let url = URL(string: "https://dummy.com/dummy?key1=WRONGVALUE")!
    XCTAssertFalse(url.hasQuery(name: "key1", value: "value1"))
  }

  func testShouldMatchURLContainingMatchingKeyAndValueWithEncodedSpace() {
    let url = URL(string: "https://dummy.com/dummy?key1=value%201")!
    XCTAssertTrue(url.hasQuery(name: "key1", value: "value 1"))
  }
}
