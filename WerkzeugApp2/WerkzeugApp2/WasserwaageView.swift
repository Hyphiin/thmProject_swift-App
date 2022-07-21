//
//  WasserwaageView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI
import CoreGraphics

struct WasserwaageView: View {
    @EnvironmentObject var motionDetector: MotionDetector
    
    let pi = Double.pi
    let generalSize: CGFloat = 320
    
    var bubbleXPos: CGFloat {
        let zeroBasedRoll = motionDetector.roll + pi / 2
        let rollAsFraction = zeroBasedRoll / pi
        return rollAsFraction * generalSize
    }
    var bubbleYPos: CGFloat {
        let zeroBasedPitch = motionDetector.pitch + pi / 2
        let pitchAsFraction = zeroBasedPitch / pi
        return pitchAsFraction * generalSize
    }
    
    //hilfsfunktionen für normale Linien
    var verticalLine: some View {
        Rectangle()
            .frame(width: 0.5, height: 40)
    }
    var horizontalLine: some View {
        Rectangle()
            .frame(width: 40, height: 0.5)
    }
    
    //hilfsComputed für Drehung(roll) und Neigung(pitch) als String
    var rollString: String {
        motionDetector.roll.describeAsFixedLengthString()
    }
    var pitchString: String {
        motionDetector.pitch.describeAsFixedLengthString()
    }

    var body: some View {
        backgroundView()
            .frame(width: generalSize, height: generalSize)
            //overlay = on top of Circle
            .overlay(
                //ZStack = on top of each other
                ZStack {
                    //Bubble:
                    Circle()
                        .foregroundColor(.accentColor)
                        .frame(width: 50, height: 50)
                        .position(x: bubbleXPos, y: bubbleYPos)
                    //kleinerer Kreis in Mitte, inkl. Fadenkreuz
                    Circle()
                        .stroke(lineWidth: 0.5)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    verticalLine
                        .foregroundColor(.white)
                    horizontalLine
                        .foregroundColor(.white)
                    
                    //Ränder
                    verticalLine
                        .position(x: generalSize / 2, y: -generalSize * 0.3)
                    verticalLine
                        .position(x: generalSize / 2, y: generalSize * 1.3)
                    horizontalLine
                        .position(x: 0, y: generalSize / 2)
                    horizontalLine
                        .position(x: generalSize, y: generalSize / 2)
                }
            )
        VStack {
            Text("Horizontal: " + rollString)
                .font(.system(.body, design: .monospaced))
            Text("Vertikal: " + pitchString)
                .font(.system(.body, design: .monospaced))
        }
        .offset(x: 0, y: 120)
        .navigationTitle("Wasserwaage")
    }
}

//etwas ausprobiert, damit Form etwas interessanter wirkt
struct backgroundView: View {
    let generalSize: CGFloat = 320
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width * 1.5
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + Hexagon.tempFloat)
                    )
                )

                Hexagon.segments.forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )

                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
            .fill(.linearGradient(
                Gradient(colors: [Color.ui.primaryDark, Color.ui.primaryLight]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
            .position(x: generalSize/2, y: generalSize/4)
        }
            .aspectRatio(1, contentMode: .fit)
    }
}

struct Hexagon {
    struct Segment {
        let line: CGPoint
        let curve: CGPoint
        let control: CGPoint
    }

    static let tempFloat: CGFloat = 0.001

    static let segments = [
        Segment(
            line:    CGPoint(x: 0.60, y: 0.05),
            curve:   CGPoint(x: 0.40, y: 0.05),
            control: CGPoint(x: 0.50, y: 0.00)
        ),
        Segment(
            line:    CGPoint(x: 0.05, y: 0.20 + tempFloat),
            curve:   CGPoint(x: 0.00, y: 0.30 + tempFloat),
            control: CGPoint(x: 0.00, y: 0.25 + tempFloat)
        ),
        Segment(
            line:    CGPoint(x: 0.00, y: 0.70 - tempFloat),
            curve:   CGPoint(x: 0.05, y: 0.80 - tempFloat),
            control: CGPoint(x: 0.00, y: 0.75 - tempFloat)
        ),
        Segment(
            line:    CGPoint(x: 0.40, y: 0.95),
            curve:   CGPoint(x: 0.60, y: 0.95),
            control: CGPoint(x: 0.50, y: 1.00)
        ),
        Segment(
            line:    CGPoint(x: 0.95, y: 0.80 - tempFloat),
            curve:   CGPoint(x: 1.00, y: 0.70 - tempFloat),
            control: CGPoint(x: 1.00, y: 0.75 - tempFloat)
        ),
        Segment(
            line:    CGPoint(x: 1.00, y: 0.30 + tempFloat),
            curve:   CGPoint(x: 0.95, y: 0.20 + tempFloat),
            control: CGPoint(x: 1.00, y: 0.25 + tempFloat)
        )
    ]
}
    
struct WasserwaageView_Previews: PreviewProvider {
    @StateObject static var detector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        WasserwaageView()
            .environmentObject(detector)
        
    }
}

