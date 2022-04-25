import SwiftUI

import SwiftUI

class SlitReceptorModel: SimulationModel {
    var simulation: WaveSlitSimulation
    var lastTime: CGFloat = 0
    
    struct Mark {
        var id: Int
        var position: CGFloat
        var value: CGFloat
        mutating func decrease() {
            value = value - .random(in: 0...0.01)
        }
    }
    var marks = [Mark]()
    
    init (id: Int = 0, title: String, description: String = "", mainColor color: Color = .blue, parameters: WaveSlitParameters, wave: Wave) {
        simulation = WaveSlitSimulation(slitParameters: parameters, leftWave: wave)
        super.init(id: id, type: .slitReceptor, title: title, description: description, mainColor: color)
        
        simulation.parent = self
    }
    
    func getReceptorWidth(fullWidth: CGFloat) -> CGFloat {
        return max(50, fullWidth / 6)
    }
    func getSimulationSize(size: CGSize) -> CGSize {
        return CGSize(width: size.width - getReceptorWidth(fullWidth: size.width), height: size.height)
    }
    func getSimulationBox(box: CGRect) -> CGRect {
        let graphWidth = getReceptorWidth(fullWidth: box.width)
        return CGRect(x: box.minX, y: box.minY, width: box.width - graphWidth, height: box.height)
    }
    override func update (time: CGFloat, size: CGSize) {
        let dt = min(time - lastTime, 1/30)
        lastTime = time
        
        simulation.update(dt: dt, size: getSimulationSize(size: size))
    }
    
    func addMark(range: CGFloat, simulationRightSize size: CGSize) {
        var id = 0
        marks.forEach { mark in
            id = max(id, mark.id)
        }
        let y = CGFloat.random(in: 0...range)
        let a = sqrt(simulation.interferenceGraph(atValue: y, rightSize: size)) * 2
        marks.append(Mark(id: id + 1, position: y, value: a))
    }
    
    override func draw(context: GraphicsContext, box: CGRect) {
        let receptorWidth = getReceptorWidth(fullWidth: box.width)
        let simulationBox = getSimulationBox(box: box)
        let receptorBox = CGRect(x: simulationBox.maxX + receptorWidth / 8, y: box.minX, width: receptorWidth * 3 / 4, height: box.height)
        
        context.fill(Path(box), with: .color(Color(uiColor: UIColor.secondarySystemBackground)))
        
        let rightSize = CGSize(width: simulationBox.width / 2, height: simulationBox.height)
        while marks.count < Int(receptorBox.height / 2) {
            addMark(range: receptorBox.height, simulationRightSize: rightSize)
        }
        marks.indices.forEach({ marks[$0].decrease() })
        var receptorContext = context
        receptorContext.clip(to: Path(receptorBox))
        receptorContext.addFilter(.blur(radius: 2))
        receptorContext.fill(Path(receptorBox), with: .color(.black))
        marks.forEach { mark in
            if mark.value < -0.1 {
                marks.removeAll { mark.id == $0.id }
            } else if mark.value > 0 {
                let color = mainColor.opacity(mark.value)
                receptorContext.stroke(Path(CGRect(x: receptorBox.minX, y: receptorBox.minY + mark.position, width: receptorBox.width, height: 0)), with: .color(color))
            }
        }
        
        simulation.draw(context: context, box: simulationBox)
        
    }
    
    override func thumbnail(context: GraphicsContext, size: CGSize, scaleDownBy scale: CGFloat) {
        marks.removeAll()
        var thumbnailContext = context
        thumbnailContext.scaleBy(x: 1/scale, y: 1/scale)
        let box = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        simulation.fill(size: getSimulationSize(size: box.size))
        draw(context: thumbnailContext, box: box)
        reset()
    }
    
    override func getData() -> SimulationData {
        return SimulationData(id: id, title: title, description: description, type: .slitReceptor, color: mainColor, parameters: simulation.slit, wave: simulation.leftWave)
    }
    
    override func reset() {
        marks.removeAll()
        simulation.reset()
    }
}
