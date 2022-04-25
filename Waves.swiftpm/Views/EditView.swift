import SwiftUI

struct EditView: View {
    
    @Binding var store: SimulationModelStore
    @State var data: SimulationData
    @Environment(\.presentationMode) var presentationMode
    @Binding var model: SimulationModel
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Title", text: $data.title)
                    ColorPicker("", selection: $data.color)
                }
                TextEditor(text: $data.description)
            }
            Section {
                Picker("Analysis", selection: $data.type) {
                    Text("None")
                        .tag(SimulationType.waveSlit)
                    Text("Receptor").tag(SimulationType.slitReceptor)
                    Text("Graph").tag(SimulationType.slitGraph)
                }
                Picker("Slit Type", selection: $data.parameters.type) {
                    Text("Single Slit")
                        .tag(SlitType.single)
                    Text("Double Slit")
                        .tag(SlitType.double)
                }
                .pickerStyle(.segmented)
                HStack {
                    Text("Slit Size")
                    Slider(value: $data.parameters.size, in: 1...40)
                }
                HStack {
                    Text("Distance\(data.parameters.type == .single ? " (Double Slit Only)" : "")")
                    Slider(value: $data.parameters.distance, in: (data.parameters.type == .single ? -0.1 : 0)...(200 + (data.parameters.type == .single ? 0.1 : 0)))
                    .disabled(data.parameters.type == .single)
                }
                VStack {
                    HStack {
                        Stepper(value: $data.parameters.waves, in: 2...32) {
                            Text("Quality")
                            ProgressView(value: log2(Double(data.parameters.waves))/6)
                        }
                    }
                    Text("Higher can be slower but more realistic")
                        .font(.caption)
                }
            }
            Section {
                HStack {
                    Text("Speed")
                    Slider(value: $data.wave.speed, in: 50...300)
                }
                HStack {
                    Text("Amplitude")
                    Slider(value: $data.wave.amplitude, in: 0...0.3)
                }
                HStack {
                    Text("Wavelength")
                    Slider(value: $data.wave.wavelength, in: 2...200)
                }
            }
            Section {
                Button {
                        model = store.modify(data: data)
                        model.reset()
                        presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save and Close")
                        .bold()
                        .foregroundColor(.accentColor)
                }
                .submitScope()
                Button("Cancel", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Delete", role: .destructive) {
                    store.remove(id: data.id)
                    presentationMode.wrappedValue.dismiss()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
//        .frame(maxWidth: 700)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Edit \(data.title)")
    }
}

struct EditView_Previews_Previews: PreviewProvider {
    static var previews: some View {
        EditView(store: .constant(SimulationModelStore.defaultStore), data: SimulationModelStore.defaultStore.models[0].getData(), model: .constant(SimulationModelStore.defaultStore.models[0]))
    }
}
