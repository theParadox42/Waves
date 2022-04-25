import SwiftUI

enum SlitType {
    case single
    case double
}
struct WaveSlitParameters: SpecialParameters {
    var type: SlitType
    var size: CGFloat
    var distance: CGFloat
    var waves: Int
    var wallRadius: CGFloat
    var wallShading: GraphicsContext.Shading
    var rightAmplitudeFactor: CGFloat {
        return 2 * sqrt(size) / CGFloat(waves)
    }
    
    init (size: CGFloat, distance: CGFloat = 0, waves: Int = 8, wallRadius: CGFloat = 7, wallShading: GraphicsContext.Shading = .color(.black)) {
        type = distance <= 0 ? .single : .double
        self.size = size
        self.distance = distance
        self.waves = type == .single ? waves : Int(ceil(Double(waves) / 2)) * 2
        self.wallRadius = wallRadius
        self.wallShading = wallShading
    }
}

class WaveSlitSimulation {
    var slit: WaveSlitParameters
    var leftWave: Wave
    var rightWaves: [Wave] = []
    public var parent: SimulationModel?
    
    init (slitParameters: WaveSlitParameters, leftWave: Wave) {
        slit = slitParameters
        self.leftWave = leftWave
    }
    
    func fill(size: CGSize) {
        reset()
        leftWave.goToDistance(distance: size.width + size.height / 2)
        update(dt: 0, size: size)
    }
    func reset() {
        leftWave.goToDistance(distance: 0)
        rightWaves.removeAll()
    }
    func createRightWaves() {
        rightWaves.removeAll()
        for i in 0..<slit.waves {
            rightWaves.append(Wave(type: .arc, distance: leftWave.timeDistance - leftWave.distance, speed: leftWave.speed, amplitude: leftWave.amplitude * slit.rightAmplitudeFactor, wavelength: leftWave.wavelength, number: i))
        }
    }
    func waveGraph(atDistance x: CGFloat, outOfWidth width: CGFloat) -> CGFloat {
        if x <= width / 2 {
            return leftWave.amplitudeAtDistance(x) 
        } else if let wave = rightWaves.first {
            return wave.relativeAmplitudeAtDistance(x - width / 2) * wave.amplitude / slit.rightAmplitudeFactor * 10 / sqrt(100 + x - width / 2)
        } else {
            return 0
        }
    }
    func yInterferenceScale(rightWidth width: CGFloat) -> CGFloat {
        // some mostly arbitrary way of correcting the differences
        return pow(0.85, slit.distance / width)
    }
    func singleInterferenceGraph(atValue: CGFloat, rightSize: CGSize) -> CGFloat {
        let y = (atValue - rightSize.height / 2) * yInterferenceScale(rightWidth: rightSize.width)
        let x = rightSize.width
        let theta = atan(y / x)
        // b = pi * slit size * sin(theta) / wavelength
        let b = CGFloat.pi * slit.size * sin(theta) / leftWave.wavelength
        
        var singleInterference = pow(sin(b)/b, 2)
        if b == 0 { singleInterference = 1 }
        if rightWaves.count > 0 {
            var amp = (rightWaves[0].timeDistance - sqrt(x * x + y * y)) / (slit.size + slit.distance / 2)
            amp = max(0, min(1, amp))
            return amp * singleInterference
        } else {
            return 0
        }
    }
    func doubleInterferenceGraph(atValue y: CGFloat, rightSize: CGSize) -> CGFloat {
        let singleInterference = singleInterferenceGraph(atValue: y, rightSize: rightSize)
        // di = cos(pi * slit distance * theta / wavelength)^2
        let doubleInterference = pow(cos(CGFloat.pi * slit.distance * atan((y - rightSize.height / 2) * yInterferenceScale(rightWidth: rightSize.width) / rightSize.width) / leftWave.wavelength), 2)
        return singleInterference * doubleInterference
    }
    func interferenceGraph(atValue: CGFloat, rightSize: CGSize) -> CGFloat {
        return slit.type == .single ? singleInterferenceGraph(atValue: atValue, rightSize: rightSize) : doubleInterferenceGraph(atValue: atValue, rightSize: rightSize)
    }
    func update(dt: CGFloat, size: CGSize) {
        
        switch leftWave.type {
        case .plane:
            leftWave.update(timePassed: dt, maxDistance: size.width / 2)
        default:
            leftWave.updateWithBounds(timePassed: dt, bound: CGSize(width: size.width / 2, height: size.height / 2))
        }
        
        if leftWave.timeDistance >= size.width / 2 {
            if rightWaves.count < slit.waves {
                createRightWaves()
            }
            for wave in rightWaves {
                wave.goToDistance(distance: leftWave.timeDistance - size.width / 2)
                wave.updateWithBounds(timePassed: 0, bound: CGSize(width: size.width / 2, height: size.height + slit.size + slit.distance / 2))
            }
        }
    }
    
    func draw(context original: GraphicsContext, box: CGRect) {
        var context = original
        context.clip(to: Path(box))
        
        if let backgroundShading = parent?.mainColor {
            context.fill(Path(box), with: .color(backgroundShading))
        } else {
            context.fill(Path(box), with: .color(.gray))
        }
        
        var leftSide = context
        leftSide.clip(to: Path(CGRect(x: box.minX, y: box.minY, width: box.width / 2, height: box.height)))
        leftWave.drawOnContext(context: leftSide, position: CGPoint(x: box.minX, y: box.midY), height: box.height)
        
        let rightFrame = CGRect(x: box.midX, y: box.minY, width: box.width / 2, height: box.height)
        var rightSide = context
        rightSide.clip(to: Path(rightFrame))
        
        // positions and draws wave based off of id(number)
        for wave in rightWaves {
            var offsetY: CGFloat = 0
            if slit.type == .single {
                offsetY = slit.waves == 1 ? 0 : CGFloat(wave.number) * slit.size / CGFloat(slit.waves - 1) - slit.size / 2
            } else if wave.number < rightWaves.count / 2 {
                offsetY = slit.waves == 2 ? -(slit.size + slit.distance) / 2 : CGFloat(wave.number) * slit.size * 2 / CGFloat(slit.waves - 1) - slit.size - slit.distance / 2
            } else {
                offsetY = slit.waves == 2 ? (slit.size + slit.distance) / 2 : CGFloat(wave.number) * slit.size * 2 / CGFloat(slit.waves - 1) - slit.size + slit.distance / 2
            }
            let pos = CGPoint(x: box.midX, y: box.midY + offsetY)
            wave.drawOnContext(context: rightSide, position: pos)
        }
        
        let wallRadius = slit.wallRadius
        let wallShading = slit.wallShading
        if slit.size <= 0 {
            context.fill(Path(CGRect(x: box.midX, y: box.minY, width: wallRadius * 2, height: box.height)), with: wallShading)
        } else if slit.type == .single {
            let wallHeight: CGFloat = box.height / 2 + wallRadius - slit.size / 2
            
            context.fill(Path(roundedRect: CGRect(x: box.midX - wallRadius, y: box.minY - wallRadius, width: wallRadius * 2, height: wallHeight), cornerRadius: wallRadius), with: wallShading)
            context.fill(Path(roundedRect: CGRect(x: box.midX - wallRadius, y: box.midY + slit.size / 2, width: wallRadius * 2, height: wallHeight), cornerRadius: wallRadius), with: wallShading)
        } else {
            let wallHeight: CGFloat = box.height / 2 + wallRadius - slit.size - slit.distance / 2
            
            context.fill(Path(roundedRect: CGRect(x: box.midX - wallRadius, y: box.minY - wallRadius, width: wallRadius * 2, height: wallHeight), cornerRadius: wallRadius), with: wallShading)
            context.fill(Path(roundedRect: CGRect(x: box.midX - wallRadius, y: box.midY - slit.distance / 2, width: wallRadius * 2, height: slit.distance), cornerRadius: wallRadius), with: wallShading)
            context.fill(Path(roundedRect: CGRect(x: box.midX - wallRadius, y: box.midY + slit.size + slit.distance / 2, width: wallRadius * 2, height: wallHeight), cornerRadius: wallRadius), with: wallShading)
        }
    }
    
}
