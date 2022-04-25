import SwiftUI

class WaveSlitModel: SimulationModel {
    var simulation: WaveSlitSimulation
    var lastTime: CGFloat = 0
    
    init (id: Int = 0, title: String, description: String = "", mainColor color: Color = .blue, parameters: WaveSlitParameters, wave: Wave) {
        simulation = WaveSlitSimulation(slitParameters: parameters, leftWave: wave)
        super.init(id: id, type: .waveSlit, title: title, description: description, mainColor: color)
        
        simulation.parent = self
    }
    override func update (time: CGFloat, size: CGSize) {
        let dt = min(time - lastTime, 1/30)
        lastTime = time
        
        simulation.update(dt: dt, size: size)
    }
    
    override func draw(context: GraphicsContext, box: CGRect) {
        simulation.draw(context: context, box: box)
    }
    
    override func thumbnail(context: GraphicsContext, size: CGSize, scaleDownBy scale: CGFloat) {
        var thumbnailContext = context
        thumbnailContext.scaleBy(x: 1/scale, y: 1/scale)
        let box = CGRect(x: 0, y: 0, width: size.width * 2, height: size.height * 2)
        simulation.fill(size: box.size)
        simulation.draw(context: thumbnailContext, box: box)
        reset()
    }
    
    override func getData() -> SimulationData {
        return SimulationData(id: id, title: title, description: description, type: .waveSlit, color: mainColor, parameters: simulation.slit, wave: simulation.leftWave)
    }
    
    override func reset() {
        simulation.reset()
    }
}
