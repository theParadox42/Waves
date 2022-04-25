//
//  Wave.swift
//  Waves and Light
//
//  Created by Nathaniel on 4/14/22.
//

import SwiftUI

enum WaveType {
    case arc
    case plane
    case radial
}
enum WaveDrawStyle {
    case blackwhite
    case opacity
}

 class Wave: ObservableObject {
     var type: WaveType
     
     public var amplitude: CGFloat
     public var frequency: CGFloat {
         2 * CGFloat.pi / wavelength
     }
     public var wavelength: CGFloat
     
     public var time: CGFloat
     public var distance: CGFloat
     var speed: CGFloat
     public var timeDistance: CGFloat
     
     public var number: Int!
     
     init (type: WaveType, distance: CGFloat = 0, speed: CGFloat = 100, amplitude: CGFloat = 0.1, wavelength: CGFloat = 40, number: Int? = nil) {
         self.type = type
         
         self.amplitude = amplitude
         self.wavelength = wavelength
         
         self.distance = distance
         self.timeDistance = distance
         self.speed = speed
         self.time = distance / speed
         
         if number != nil {
             self.number = number
         }
    }
    
     public func update(timePassed dt: CGFloat, maxDistance: CGFloat) {
         time += dt
         timeDistance = time * speed
         distance = min(timeDistance, maxDistance)
    }
     public func updateWithBounds(timePassed dt: CGFloat, bound: CGSize) {
         update(timePassed: dt, maxDistance: sqrt(bound.width * bound.width + bound.height * bound.height))
    }
     public func goToDistance(distance: CGFloat) {
         self.distance = distance
         timeDistance = distance
         time = distance / speed
     }
     public func goToBound(bound: CGSize) {
         let distance = sqrt(bound.width * bound.width + bound.height * bound.height)
         goToDistance(distance: distance)
     }
     func maxAmplitudeAtDistance(_ d: CGFloat) -> CGFloat {
         return type == .plane ? amplitude : amplitude / sqrt(d)
     }
     func relativeAmplitudeAtDistance(_ d: CGFloat) -> CGFloat {
         return sin(max(timeDistance - d, 0) * frequency)
     }
     public func amplitudeAtDistance(_ d: CGFloat) -> CGFloat {
         return relativeAmplitudeAtDistance(d) * maxAmplitudeAtDistance(d)
     }
     
     public func drawOnContext(context: GraphicsContext, position: CGPoint, height: CGFloat = 0, drawStyle: WaveDrawStyle = .opacity) {
         switch type {
         case .plane:
             let upperY = position.y - height / 2
             let lowerY = position.y + height / 2
             for i in 0...Int(distance) {
                 let d = CGFloat(i)
                 var p = Path()
                 p.move(to: CGPoint(x: position.x + d, y: upperY))
                 p.addLine(to: CGPoint(x: position.x + d, y: lowerY))
                 let intensity = amplitudeAtDistance(d)
                 switch drawStyle {
                 case .blackwhite:
                     context.stroke(p, with: .color(white: intensity + 0.5))
                     break
                 case .opacity:
                     context.stroke(p, with: .color(.sRGB, white: intensity > 0 ? 1 : 0, opacity: intensity.magnitude * 2))
                 }
                 
             }
         case .arc:
             for i in 0...Int(distance) {
                 let d = CGFloat(i)
                 var p = Path()
                 p.addArc(center: position, radius: d, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 90), clockwise: false)
                 let intensity = amplitudeAtDistance(d)
                 switch drawStyle {
                     case .blackwhite:
                     context.stroke(p, with: .color(white: intensity + 0.5))
                     case .opacity:
                     context.stroke(p, with: .color(.sRGBLinear, white: intensity > 0 ? 1 : 0, opacity: intensity.magnitude * 2))
                 }
                 
             }
         case .radial:
             for i in 0...Int(distance) {
                 let d = CGFloat(i)
                 let p = Path(ellipseIn: CGRect(x: position.x - d, y: position.y - d, width: d * 2, height: d * 2))
                 let intensity = amplitudeAtDistance(d)
                 switch drawStyle {
                 case .blackwhite:
                     context.stroke(p, with: .color(white: intensity + 0.5))
                 case .opacity:
                     context.stroke(p, with: .color(.sRGBLinear, white: intensity > 0 ? 1 : 0, opacity: intensity.magnitude * 2))
                 }
             }
         }
     }
}
