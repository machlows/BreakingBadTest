import XCTest
@testable import BreakingBad

class RequestTests: XCTestCase {    
    func testCharactersRequest() throws {
        let sut = Request.characters
        let expectedURL = URL(string: "https://www.breakingbadapi.com/api/characters")
        XCTAssertEqual(sut.url, expectedURL)
    }
    
    func testQuotesRequest() throws {
        let sut = Request.quotes("test")
        let expectedURL = URL(string: "https://www.breakingbadapi.com/api/quote?author=test")
        XCTAssertEqual(sut.url, expectedURL)
    }
}
