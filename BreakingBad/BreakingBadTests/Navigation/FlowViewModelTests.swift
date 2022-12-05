import XCTest
@testable import BreakingBad

class FlowViewModelTests: XCTestCase {
    
    func testNavigatesWhenSelectedCharacter() throws {
        let sut = FlowViewModel()
        XCTAssertEqual(sut.navigationPath.count, 0)
        
        let charactersViewModel = sut.makeCharactersViewModel()
        let testCharacter = Character(id: 0, name: "", image: "")
        charactersViewModel.items = [CharacterViewItemModel(character: testCharacter, isLiked: false)]
        charactersViewModel.didSelect(index: 0)
        XCTAssertEqual(sut.navigationPath.count, 1)
        
        if case Screen.detailsScreen(_) = sut.navigationPath.last! {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false)
        }
    }
}
