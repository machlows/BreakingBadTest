import SwiftUI

@main
struct BreakingBadApp: App {
    var flowViewModel = FlowViewModel()
    
    var body: some Scene {
        WindowGroup {
            FlowView(viewModel: flowViewModel)
        }
    }
}
