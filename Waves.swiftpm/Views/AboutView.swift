import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Hello! Welcome to my App!")
                    .font(.title)
                    .padding(.top)
                Text("Feel free to head right over to the simulations page and check out the preset simulations. Go ahead and edit them and see what changes, even try and make your own. Have fun and learn what has an affect on what. After you've simulated, waved, and simulated some more, go check out the experiments page, and discover the applications of this interference in the real world.")
                Divider()
                Text("About this app")
                    .font(.title)
                    .padding(.top)
                Text("This app was made by Nathaniel Fargo exclusively for the Swift Student challenge. All images, including the logo, were designed by me, specifically for this app, and under no copyright protections. I probably spent at least 20 hours on this app, and had a lot of fun doing so. My passion for physics fueled the whole ride, paired with my enthusiasm for coding and Apple development. Everything is built on SwiftUI, including the simulations, which run on an animation TimelineView and a Canvas.")
                Divider()
                Text("Graph Technicalities")
                    .font(.title)
                    .padding(.top)
                Text("The wave graph form and receptor are occasionally off, especially when the distance or size of slits are large. This is due to the graph forms being calculated at an infinite distance and being scaled back to a finite one. Since the distances the secondary waves travel is relatively short this approximation can get off, but you'll have to trust me that at larger distances it would be accurate. These distances in fact can be modeled simply by decreasing the wavelength of the wave, and distance and size of the slits. Try it!")
                Divider()
            }
        }
        .frame(maxWidth: 600)
        .padding(.horizontal)
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(store: .constant(SimulationModelStore.defaultStore))
            AboutView()
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
