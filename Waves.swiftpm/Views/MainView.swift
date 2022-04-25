import SwiftUI

struct MainView: View {
    
    @Binding var store: SimulationModelStore
    
    var body: some View {
        List {
            NavigationLink(destination: AboutView()) {
                Label("About", systemImage: "info.circle")
            }
            NavigationLink(destination: SimulationMenuView(store: $store)) { 
                Label("Simulations", systemImage: "wave.3.right")
            }
            NavigationLink(destination: ExperimentsView()) { 
                Label("Real World Experiments", systemImage: "chart.xyaxis.line")
            }
        }
        .navigationTitle("Waves")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(store: .constant(SimulationModelStore.defaultStore))
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
