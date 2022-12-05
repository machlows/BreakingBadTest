import SwiftUI

struct CharactersScene: View {
    @StateObject var viewModel: CharactersViewModel
    
    var body: some View {
        NavigationView {
            postsView
        }
        .navigationBarTitle("All characters", displayMode: .large)
        .onAppear(perform: viewModel.loadData)
    }
    
    private var postsView: some View {
        List {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, model in
                characterCardView(model)
                    .padding(.horizontal, 4)
                    .onTapGesture { viewModel.didSelect(index: index) }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    private func characterCardView(_ model: CharacterViewItemModel) -> some View {
        HStack() {
            Text(model.character.name)
                .font(.headline)
            Spacer()
            likeButton(model)
        }
        .padding()
    }
    
    private func likeButton(_ model: CharacterViewItemModel) -> some View {
        if model.isLiked {
            return Button(role: .destructive, action: {
                viewModel.didUnlikeCharacter(model.character.id)
            }) {
                Label("", systemImage: "hand.thumbsup.fill")
            }
        } else {
            return Button(role: .destructive, action: {
                viewModel.didLikeCharacter(model.character.id)
            }) {
                Label("", systemImage: "hand.thumbsup")
            }
        }
    }
}
