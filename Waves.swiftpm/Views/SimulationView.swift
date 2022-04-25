//
//  SimulationView.swift
//  Quantum Introductions
//
//  Created by Nathaniel on 4/17/22.
//

import SwiftUI

struct SimulationView: View {
    
    @Binding var store: SimulationModelStore
    @State var model: SimulationModel
    
    var body: some View {
        VStack {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    
                    model.update(time: now, size:  size)
                    model.draw(context: context, box: CGRect(origin: .zero, size: size))
                    
                }
                .overlay { 
                    NavigationLink(destination: EditView(store: $store, data: model.getData(), model: $model)) { 
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(Color(.displayP3, red: 1, green: 1, blue: 1, opacity: 0.8))
                            .shadow(radius: 5)
                            .font(.custom("", size: 50))
                            .position(x: 30, y: 30)
                     }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 15)
            if let description = model.description {
                Text(description)
            }
        }
        .frame(maxWidth: 600)
        .navigationTitle(model.title)
        .padding()
    }
    
}
struct SimulationView_Previews: PreviewProvider {
    @Binding var presented: Bool
    static var previews: some View {
        NavigationView {
            SimulationView(store: .constant(SimulationModelStore.defaultStore), model: WaveSlitModel(title: "Double Slit Preview", description: "Here's a preview of what a double slit simulation would look like", parameters: WaveSlitParameters(size: 25, distance: 50, waves: 5), wave: Wave(type: .plane)))
        }
    }
}
