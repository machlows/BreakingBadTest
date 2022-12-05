import SwiftUI

struct FlowView: View {
    @StateObject var viewModel: FlowViewModel

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack() {
                CharactersScene(viewModel: viewModel.makeCharactersViewModel())
            }
            .navigationDestination(for: Screen.self) {screen in
                switch screen {
                case .detailsScreen(let viewModel):
                    DetailsScene(viewModel: viewModel)
                }
            }
        }
    }
}
