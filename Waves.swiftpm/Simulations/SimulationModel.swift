import SwiftUI

protocol SpecialParameters { }

class SimulationData: ObservableObject {
    var id: Int
    var title: String
    var description: String
    var type: SimulationType
    var color: Color
    var parameters: WaveSlitParameters!
    var wave: Wave!
    
    init (id: Int = 0, title: String, description: String = "", type: SimulationType, color: Color = .blue) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.color = color
    }
    convenience init (id: Int = 0, title: String, description: String = "", type: SimulationType, color: Color = .blue, parameters: WaveSlitParameters, wave: Wave) {
        self.init(id: id, title: title, description: description, type: type, color: color)
        self.parameters = parameters
        self.wave = wave
    }
}

enum SimulationType: Equatable {
    case waveSlit
    case slitReceptor
    case slitGraph
}

class SimulationModel: ObservableObject, Identifiable {
    
    var id: Int
    var type: SimulationType
    var title: String
    var description: String
    var mainColor: Color
    
    init(id: Int = 0, type: SimulationType, title: String, description: String = "", mainColor: Color = .white) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.mainColor = mainColor
    }
    func update(time: CGFloat, size: CGSize) {
        print("empty model")
    }
    func draw(context: GraphicsContext, box: CGRect) {
        print("empty model")
    }
    func thumbnail(context: GraphicsContext, size: CGSize, scaleDownBy: CGFloat) {
        print("empty model")
    }
    func getData() -> SimulationData {
        return SimulationData(id: id, title: title, description: description, type: .waveSlit)
    }
    func reset() { 
        print("empty model")
    }
}


