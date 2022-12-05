import XCTest
@testable import BreakingBad

class APIClientTests: XCTestCase {
    
    func testSuccessfullyPerformingCharacterRequest() throws {
        let session = URLSession(mockResponder: Character.MockDataURLResponder.self)
        let sut = ApiClient(with: session)
        
        let publisher = sut.characters()
        let result = try awaitCompletion(of: publisher)
        
        XCTAssertEqual(result, [Character.MockDataURLResponder.characters])
    }
    
    func testSuccessfullyPerformingQuotesRequest() throws {
        let session = URLSession(mockResponder: Quote.MockDataURLResponder.self)
        let sut = ApiClient(with: session)
        
        let publisher = sut.quotes(characterName: "")
        let result = try awaitCompletion(of: publisher)
        
        XCTAssertEqual(result, [Quote.MockDataURLResponder.quotes])
    }
}
