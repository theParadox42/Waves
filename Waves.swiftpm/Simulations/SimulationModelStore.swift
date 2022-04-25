import SwiftUI

struct SimulationModelStore {
    var models: [SimulationModel] = []
    
    static var defaultStore: Self {
        var data = Self()
        
        data.append(title: "Graph Model", description: "To get a better understanding of interference pattern, we can convert our receptor into a clean graph model. While this graph servers as an ideal approximation that is often off, it shows us how variables affect interference.", color: Color(red: 0.5, green: 0.4, blue: 1), type: .slitGraph, wave: Wave(type: .plane, wavelength: 20), parameters: WaveSlitParameters(size: 10, distance: 100))
        
        data.append(title: "Double Slit Receptor", description: "Next we can measure the amplification and interference of the waves. The bright spots represent amplification while the darker spots represent destructive interference. Feel free to keep messing around!", color: Color(red: 0.4, green: 0.5, blue: 1), type: .slitReceptor, wave: Wave(type: .plane, wavelength: 30), parameters: WaveSlitParameters(size: 10, distance: 100))
        
        data.append(title: "Double Slit", description: "Here we open up a second slit, leaving room for these two waves to interfere with each other, creating different patterns", color: Color(red: 0.3, green: 0.6, blue: 1), type: .waveSlit, wave: Wave(type: .plane, wavelength: 40), parameters: WaveSlitParameters(size: 10, distance: 100))
        
        data.append(title: "Single Slit", description: "In this first simulation, we send a plane wave through a small gap that spreads out in an arcing fashion. Feel free to hit the Edit button to change things around!", color: Color(red: 0.2, green: 0.7, blue: 1), type: .waveSlit, wave: Wave(type: .plane, wavelength: 50), parameters: WaveSlitParameters(size: 10))
        
        data.models.sort { $0.id > $1.id }
        
        return data
    }
    
    mutating func createModel(id: Int, title: String, description: String, color: Color, type: SimulationType, wave: Wave, parameters: SpecialParameters) -> SimulationModel {
        let simulationModel: SimulationModel!
        switch type {
        case .waveSlit:
            simulationModel = WaveSlitModel(id: id, title: title, description: description, mainColor: color, parameters: parameters as! WaveSlitParameters, wave: wave)
        case .slitReceptor:
            simulationModel = SlitReceptorModel(id: id, title: title, description: description, mainColor: color, parameters: parameters as! WaveSlitParameters, wave: wave)
        case .slitGraph:
            simulationModel = SlitGraphModel(id: id, title: title, description: description, mainColor: color, parameters: parameters as! WaveSlitParameters, wave: wave)
        }
        return simulationModel
    }
    
    @discardableResult
    mutating func append(title: String, description: String = "", color: Color = .gray, type: SimulationType, wave: Wave, parameters: SpecialParameters) -> SimulationModel {
        var id = 0
        models.forEach { model in
            id = max(id, model.id)
        }
        let simulationModel = createModel(id: id + 1, title: title, description: description, color: color, type: type, wave: wave, parameters: parameters)
        models.append(simulationModel)
        return simulationModel
    }
    @discardableResult
    mutating func append(data: SimulationData) -> SimulationModel {
        return append(title: data.title, description: data.description, color: data.color, type: data.type, wave: data.wave, parameters: data.parameters)
    }
    @discardableResult
    mutating func modify(data: SimulationData) -> SimulationModel {
        let newModel = createModel(id: data.id, title: data.title, description: data.description, color: data.color, type: data.type, wave: data.wave, parameters: data.parameters)
        let i = models.firstIndex { $0.id == data.id }
        if let index = i {
            if index >= 0 {
                models[index] = newModel
            }
        }
        return newModel
    }
    @discardableResult
    mutating func modifyOrAdd(data: SimulationData) -> SimulationModel {
        remove(id: data.id)
        return append(data: data)
    }
    
    mutating func remove(id: Int) {
        models.removeAll(where: { $0.id == id })
    }
}
