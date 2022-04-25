import SwiftUI

struct ExperimentsView: View {
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 3.1, maximum: UIScreen.main.bounds.width / 2))], alignment: .center) { 
                    VStack {
                        Text("Light")
                            .font(.title)
                            .bold()
                            .padding(.vertical, 5)
                        Text("As seen by our simulations, waves have the ability to amplify or interfere, with themselves and each other. By passing light through a double slit, we can observe that it is a wave, because the diffraction pattern models a wave. Each wavelength or frequency of a wave has a different interference patter. In the case of light, this is the color. By sending white light through a very small double slit we split each intividual color into its respective pattern, creating a rainbow.")
                    }
                    VStack {
                        Image("slit.rainbow", bundle: nil)
                            .resizable()
                            .aspectRatio(5/6, contentMode: .fill)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .shadow(radius: 10)
                        Text("An example of what a diffraction pattern of white light through two small slits would look like")
                            .font(.caption)
                    }
                    .frame(maxWidth: 350)
                    VStack {
                        Text("Electrons")
                            .font(.title)
                            .bold()
                            .padding(.vertical, 5)
                        Text("While most people consider electrons as particles instead of waves, when we pass them through a double slit, something very strange happens: they interfere with themselves. This phenomena occurs even when just a single electron is shot through. From this it is conlucded that when left unobservered electrons, and matter alike, act like a wave. This and related discoveries have led to the development of quantum mechanics.")
                    }
                    VStack {
                        Image("slit.electron", bundle: nil)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .shadow(radius: 2)
                        Text("Expected electron particle double slit pattern VS actual electron wave interference pattern.")
                            .font(.caption)
                    }
                    .frame(maxWidth: 500)
                    VStack {
                        Text("Sound")
                            .font(.title)
                            .bold()
                            .padding(.vertical, 5)
                        Text("Sound can be characterized by a physical compression wave. And thus, these waves can amplify, or interfere with each other. A more common example of this is noise cancelling headphones, which use inverse waves to cancel out sound. For a common example, instead of sending sound through two slits, we can think of a sound system with two large speakers. The waves extended from these speakers at certain frequencies and distance can interfere or amplify just a few feet apart, adding another challenge or opportunity for sound technicians.")
                    }
                    VStack {
                        Image("slit.sound", bundle: nil)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .shadow(radius: 4)
                        Text("A two speaker system sending interfering waves")
                            .font(.caption)
                    }
                    .frame(maxWidth: 500)
                    VStack {
                        Text("Radio")
                            .font(.title)
                            .bold()
                            .padding(.vertical, 5)
                        Text("Since radios, like light, are another form of Electromagnetic radiation, they can be characterized by a wave. Similar to sound and speakers, radio antennas can serve as two different wave sources. If in similar proximity, these two antennas can serve to amplify and interfere with various connections. This interference will vary proportional to the wavelength, in the case of radio waves: up to several meters!")
                    }
                    VStack {
                        Image("slit.radio", bundle: nil)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .shadow(radius: 4)
                        Text("An example of double wave interference to a car")
                            .font(.caption)
                    }
                    .frame(maxWidth: 500)
                }
            }
            .padding()
            .navigationTitle("Real World Experiments")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct ExperimentsView_Previews: PreviewProvider {
        static var previews: some View {
            ExperimentsView()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
