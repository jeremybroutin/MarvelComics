import XCTest
@testable import MarvelComics

class MarvelAuthenticationTests: XCTestCase {

  var sut: MarvelAuthentication!

  override func setUp() {
    super.setUp()
    sut = MarvelAuthentication()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testPublicKey_ShouldHave32Characters() {
    XCTAssertEqual(sut.publicKey.count, 32)
  }

  func testPrivateKey_ShouldHave40Characters() {
    XCTAssertEqual(sut.privateKey.count, 40)
  }

  func testMD5OfKnownString_ShouldYieldKnownResult() {
    let md5 = "abc".MD5Digest()
    XCTAssertEqual(md5, "900150983cd24fb0d6963f7d28e17f72")
  }

  func testURLParameters_ShouldHaveTimeStampPublicKeyAndHashedConcatenation() {
    sut.md5 = { str in return "MD5" + str + "MD5" }
    let params = sut.urlParameters(timeStamp: "TimeStamp")
    XCTAssertEqual(params, "&ts=TimeStamp&apikey=Public&hash=MD5TimeStamp\(sut.publicKey)\(sut.privateKey)MD5")
  }

  func testURLParameters_ShouldChangeAcrossInvocations() {
    // timeStamp parameter can be omitted due to available default implementation.
    let params1 = sut.urlParameters()
    let params2 = sut.urlParameters()

    XCTAssertNotEqual(params1, params2)
  }

}
