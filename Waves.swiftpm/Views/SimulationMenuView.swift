import SwiftUI

struct SimulationMenuView: View {
    
    @Binding var store: SimulationModelStore
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], alignment: .leading) {
                ForEach(store.models) { model in
                    NavigationLink(destination: SimulationView(store: $store, model: model)) {
                        VStack {
                            Canvas { context, size in 
                                model.thumbnail(context: context, size: size, scaleDownBy: 2)
                            }
                            .frame(height: 120)
                            Text(model.title)
                                .padding(.bottom, 10)
                                .frame(width: 170)
                                .foregroundColor(model.mainColor)
                        }
                        .background(.thickMaterial).clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    }
                }
                Button {
                    store.append(data: SimulationData(title: "Simulation #\(store.models.count + 1)", type: .waveSlit, color: Color(.sRGB, red: Double.random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1), parameters: WaveSlitParameters(size: 10), wave: Wave(type: .plane)))
                } label: {
                    Image(systemName: "plus.rectangle")
                        .font(.largeTitle)
                        .frame(maxWidth: 300, minHeight: 150)
                        .background(Material.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }

//                NavigationLink(destination: EditView(store: $store, data: SimulationData(title: "New Simulation", type: .waveSlit, parameters: WaveSlitParameters(size: 10), wave: Wave(type: .plane)), model: .constant(SimulationModel(type: .waveSlit, title: "New Simulation"))), label: {
//
//                })
            }
        }
        .navigationTitle("Simulations")
        .padding()
    }
}

struct SimulationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(store: .constant(.defaultStore))
            SimulationMenuView(store: .constant(.defaultStore))
        }
    }
}
