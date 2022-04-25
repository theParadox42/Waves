import SwiftUI

@main
struct WavesApp: App {
    
    @State private var store: SimulationModelStore = .defaultStore
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(store: $store)
                AboutView()
            }
        }
    }
}
