//
//  SeismometerView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct SeismometerView: View{
    @EnvironmentObject var motionDetector: MotionDetector
    
    let needleAnchor = UnitPoint(x: 0.5, y: 1)
    let amplification = 2.0
    var rotationAngle: Angle {
        Angle(radians: -motionDetector.zAcceleration * amplification)
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .bottom) {
                //GaugeBackground(width: 250)
                Rectangle()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 5, height: 190)
                    .rotationEffect(rotationAngle, anchor: needleAnchor)
                    .overlay {
                        VStack {
                            Spacer()
                            Circle()
                                .stroke(lineWidth: 3)
                                .fill()
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color.accentColor)
                                .background(Color.white)
                                .offset(x: 0, y: 5)
                        }
                    }
            }

            Spacer()
            
            Text("\(motionDetector.zAcceleration.describeAsFixedLengthString())")
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)

            Spacer()
        }
        
        .navigationTitle("Seismometer")
    }
}

struct NeedleSeismometer_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        SeismometerView()
            .environmentObject(detector)
    }
}
