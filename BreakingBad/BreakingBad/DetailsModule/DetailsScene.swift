import SwiftUI

struct DetailsScene: View {
    @StateObject var viewModel: DetailsViewModel
    
    var body: some View {
        NavigationView {
            commentsView
                .ignoresSafeArea()
        }
        .onAppear(perform: viewModel.loadData)
    }
    
    private var commentsView: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: viewModel.characterDetails.character.image)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .top)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                HStack() {
                    Text(viewModel.characterDetails.character.name)
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                    Spacer()
                    likeButton()
                    
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
           quotesList()
        }
    }
    
    private func likeButton() -> some View {
        if viewModel.characterDetails.isLiked {
            return Button(role: .destructive, action: {
                viewModel.didUnlikeCharacter(viewModel.characterDetails.character.id)
            }) {
                Label("", systemImage: "hand.thumbsup.fill")
                    .foregroundColor(.blue)
            }
        } else {
            return Button(role: .destructive, action: {
                viewModel.didLikeCharacter(viewModel.characterDetails.character.id)
            }) {
                Label("", systemImage: "hand.thumbsup")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func quotesList() -> some View {
        List {
            ForEach(viewModel.quotes) { quote in
                Text(quote.quote)
                    .font(.headline)
                    .padding(.horizontal, 4)
            }
        }
    }
}
