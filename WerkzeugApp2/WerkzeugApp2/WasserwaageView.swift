//
//  WasserwaageView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct WasserwaageView: View {
    @EnvironmentObject var motionDetector: MotionDetector
    
    let range = Double.pi
    let levelSize: CGFloat = 300
    
    var bubbleXPos: CGFloat {
        let zeroBasedRoll = motionDetector.roll + range / 2
        let rollAsFraction = zeroBasedRoll / range
        return rollAsFraction * levelSize
    }
    var bubbleYPos: CGFloat {
        let zeroBasedPitch = motionDetector.pitch + range / 2
        let pitchAsFraction = zeroBasedPitch / range
        return pitchAsFraction * levelSize
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
    
    var rollString: String {
        motionDetector.roll.describeAsFixedLengthString()
    }

    var pitchString: String {
        motionDetector.pitch.describeAsFixedLengthString()
    }

    var body: some View {    
        Circle()
            .foregroundStyle(Color.secondary.opacity(0.25))
            .frame(width: levelSize, height: levelSize)
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
                    verticalLine
                    horizontalLine
                    
                    //Ränder
                    verticalLine
                        .position(x: levelSize / 2, y: 0)
                    verticalLine
                        .position(x: levelSize / 2, y: levelSize)
                    horizontalLine
                        .position(x: 0, y: levelSize / 2)
                    horizontalLine
                        .position(x: levelSize, y: levelSize / 2)
                }
            )
        VStack {
            Text("Horizontal: " + rollString)
                .font(.system(.body, design: .monospaced))
            Text("Vertikal: " + pitchString)
                .font(.system(.body, design: .monospaced))
        }
        .offset(x: 0, y: 50)
        .navigationTitle("Wasserwaage")
    }
}

struct WasserwaageView_Previews: PreviewProvider {
    @StateObject static var detector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        WasserwaageView()
            .environmentObject(detector)
        
    }
}
