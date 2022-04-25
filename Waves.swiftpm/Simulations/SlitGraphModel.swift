import SwiftUI

class SlitGraphModel: SimulationModel {
    var simulation: WaveSlitSimulation
    var lastTime: CGFloat = 0
    
    init (id: Int = 0, title: String, description: String = "", mainColor color: Color = .blue, parameters: WaveSlitParameters, wave: Wave) {
        simulation = WaveSlitSimulation(slitParameters: parameters, leftWave: wave)
        super.init(id: id, type: .slitGraph, title: title, description: description, mainColor: color)
        
        simulation.parent = self
    }
    
    func getGraphSize(size: CGSize) -> CGSize {
        let dimension = max(min(size.width, size.height, 600) / 6, 50)
        return CGSize(width: dimension, height: dimension)
    }
    func getSimulationSize(size: CGSize) -> CGSize {
        let graphSize = getGraphSize(size: size)
        return CGSize(width: size.width - graphSize.width, height: size.height - graphSize.height)
    }
    func getSimulationBox(box: CGRect) -> CGRect {
        let graphSize = getGraphSize(size: box.size)
        return CGRect(x: box.minX, y: box.minY + graphSize.height, width: box.width - graphSize.width, height: box.height - graphSize.height)
    }
    override func update (time: CGFloat, size: CGSize) {
        let dt = min(time - lastTime, 1/30)
        lastTime = time
        
        simulation.update(dt: dt, size: getSimulationSize(size: size))
    }
    
    override func draw(context: GraphicsContext, box: CGRect) {
        let graphSize = getGraphSize(size: box.size)
        let simulationBox = getSimulationBox(box: box)
        
        context.fill(Path(box), with: .color(Color(uiColor: UIColor.secondarySystemBackground)))
        context.fill(Path(CGRect(x: simulationBox.maxX, y: box.minX, width: graphSize.width, height: graphSize.height)), with: .color(mainColor))
        
        drawWaveGraph(context: context, box: CGRect(x: box.minX, y: box.minY, width: simulationBox.width, height: graphSize.height))
        
        
        drawInterferenceGraph(rightSimulationSize: CGSize(width: simulationBox.width / 2, height: simulationBox.height), context: context, drawBox: CGRect(x: simulationBox.maxX, y: simulationBox.minY, width: graphSize.width, height: simulationBox.height))
        
        simulation.draw(context: context, box: simulationBox)
        
    }
    
    func drawWaveGraph(context: GraphicsContext, box: CGRect) {
        let graphPath = Path { path in
            path.move(to: CGPoint(x: box.minX, y: box.midY - simulation.waveGraph(atDistance: 0, outOfWidth: box.width) * box.height))
            for i in 0...Int(box.width / 2) {
                let x = CGFloat(i * 2)
                let amplitude = simulation.waveGraph(atDistance: x, outOfWidth: box.width)
                path.addLine(to: CGPoint(x: box.minX + x, y: box.midY - amplitude * box.height))
            }
        }
        
        context.stroke(Path({ $0.addLines([CGPoint(x: box.minX, y: box.midY), CGPoint(x: box.midX, y: box.midY), CGPoint(x: box.midX, y: box.minY), CGPoint(x: box.midX, y: box.maxY), CGPoint(x: box.midX, y: box.midY), CGPoint(x: box.maxX, y: box.midY)]) }), with: .color(.gray))
        
        context.stroke(graphPath, with: .color(mainColor), lineWidth: 2)
        
        
    }
    
    func drawInterferenceGraph(rightSimulationSize: CGSize, context: GraphicsContext, drawBox: CGRect) {
        let graphFrame = CGRect(x: drawBox.minX + drawBox.width / 8, y: drawBox.minY, width: drawBox.width * 3 / 4, height: drawBox.height)
        func getX(_ y: CGFloat, graph: (_: CGFloat, _: CGSize) -> CGFloat) -> CGFloat {
            return graphFrame.minX + graph(y, rightSimulationSize) * graphFrame.width
        }
        func drawGraph(path: inout Path, graph: (_: CGFloat, _: CGSize) -> CGFloat) {
            path.move(to: CGPoint(x: getX(0, graph: graph), y: drawBox.minY))
            for i in 1...Int(drawBox.height / 2) {
                let y = CGFloat(i * 2)
                path.addLine(to: CGPoint(x: getX(y, graph: graph), y: y + drawBox.minY))
            }
        }
        context.stroke(Path({ $0.addLines([CGPoint(x: graphFrame.minX, y: graphFrame.minY), CGPoint(x: graphFrame.minX, y: graphFrame.maxY)])}), with: .color(.gray))
        let singleInterferenceGraphPath = Path { path in 
            drawGraph(path: &path, graph: simulation.singleInterferenceGraph(atValue:rightSize:))
        }
        if simulation.slit.type == .single {
            context.stroke(singleInterferenceGraphPath, with: .color(mainColor), lineWidth: 2)
        } else {
            let doubleInterferenceGraphPath = Path({ path in 
                drawGraph(path: &path, graph: simulation.doubleInterferenceGraph(atValue:rightSize:))
            })
            context.stroke(singleInterferenceGraphPath, with: .color(.gray), lineWidth: 1)
            context.stroke(doubleInterferenceGraphPath, with: .color(mainColor), lineWidth: 2)
        }
        
    }
    
    override func thumbnail(context: GraphicsContext, size: CGSize, scaleDownBy scale: CGFloat) {
        var thumbnailContext = context
        thumbnailContext.scaleBy(x: 1/scale, y: 1/scale)
        let box = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        simulation.fill(size: getSimulationSize(size: box.size))
        draw(context: thumbnailContext, box: box)
        reset()
    }
    
    override func getData() -> SimulationData {
        return SimulationData(id: id, title: title, description: description, type: .slitGraph, color: mainColor, parameters: simulation.slit, wave: simulation.leftWave)
    }
    override func reset() {
        simulation.reset()
    }
}
