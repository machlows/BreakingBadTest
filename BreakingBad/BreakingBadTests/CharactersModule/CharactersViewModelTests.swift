import XCTest
import Combine
@testable import BreakingBad

class CharactersViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func testLoadDataForUnlikedCharacter() {
        let apiClientMock = ApiClientMock()
        let sut = CharactersViewModel(apiClient: apiClientMock,
                                      likedCharactersService: LikedCharactersServiceMock())
        let testData = [Character(id: 0,
                                  name: "name",
                                  image: "image")]
        apiClientMock.charactersToReturn = testData
        
        sut.loadData()
        
        let expectedData = [CharacterViewItemModel(character: testData.first!,
                                                   isLiked: false)]
        
        sut.$items
            .dropFirst()
            .sink { models in
                XCTAssertEqual(models, expectedData)
            }
            .store(in: &cancellables)
    }
    
    func testLoadDataForLikedCharacter() {
        let apiClientMock = ApiClientMock()
        let likedServiceMock = LikedCharactersServiceMock()
        let sut = CharactersViewModel(apiClient: apiClientMock,
                                      likedCharactersService: likedServiceMock )
        let testData = [Character(id: 0, name: "name",
                                  image: "image")]
        apiClientMock.charactersToReturn = testData
        likedServiceMock.likedCharactersId = [0]
        
        sut.loadData()
        
        let expectedData = [CharacterViewItemModel(character: testData.first!,
                                                   isLiked: true)]
        
        sut.$items
            .dropFirst()
            .sink { models in
                XCTAssertEqual(models, expectedData)
            }
            .store(in: &cancellables)
    }
    
    func testDidSelectCharacter() {
        let apiClientMock = ApiClientMock()
        let likedServiceMock = LikedCharactersServiceMock()
        let sut = CharactersViewModel(apiClient: apiClientMock,
                                      likedCharactersService: likedServiceMock)
        
        let testCharacter = Character(id: 0,
                                      name: "",
                                      image: "")
        sut.items = [CharacterViewItemModel(character: testCharacter,
                                           isLiked: false)]
        
        sut.didSelect(index: 0)
        
        sut.didSelectCharacter.sink { character in
            XCTAssertEqual(character, testCharacter)
        }
        .store(in: &cancellables)
    }
    
    func testDidLikeCharacter() {
        let apiClientMock = ApiClientMock()
        let likedServiceMock = LikedCharactersServiceMock()
        let sut = CharactersViewModel(apiClient: apiClientMock,
                                      likedCharactersService: likedServiceMock)
        
        let testCharacter = Character(id: 0,
                                      name: "",
                                      image: "")
        sut.items = [CharacterViewItemModel(character: testCharacter,
                                           isLiked: false)]
        
        sut.didLikeCharacter(0)
        
        let expectedData = [CharacterViewItemModel(character: testCharacter,
                                                   isLiked: true)]
        sut.$items
            .dropFirst()
            .sink { models in
                XCTAssertEqual(models, expectedData)
            }
            .store(in: &cancellables)
        
        XCTAssertTrue(likedServiceMock.likedCharactersId.contains(0))
    }
    
    func testDidUnlikeCharacter() {
        let apiClientMock = ApiClientMock()
        let likedServiceMock = LikedCharactersServiceMock()
        let sut = CharactersViewModel(apiClient: apiClientMock,
                                      likedCharactersService: likedServiceMock)
        likedServiceMock.likedCharactersId = [0]
        let testCharacter = Character(id: 0,
                                      name: "",
                                      image: "")
        sut.items = [CharacterViewItemModel(character: testCharacter,
                                           isLiked: true)]
        
        sut.didUnlikeCharacter(0)
        
        let expectedData = [CharacterViewItemModel(character: testCharacter,
                                                   isLiked: false)]
        sut.$items
            .dropFirst()
            .sink { models in
                XCTAssertEqual(models, expectedData)
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(likedServiceMock.likedCharactersId.contains(0))
    }
}
