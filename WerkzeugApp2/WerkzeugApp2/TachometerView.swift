//
//  TachometerView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct TachometerView: View {
    @EnvironmentObject var motionDetector: MotionDetector
    @State private var stateValue = 25.0
    
    let coveredRadius: Double = 225// 0 - 360°
    let maxValue: Int = 100
    let steperSplit: Int = 10
    
    
   
    @State var speedX: Int = 0
    
    var speed: Int{
        let currentTime = CACurrentMediaTime();
        let prevTime = CACurrentMediaTime() - 0.01;
        
        let xAcceleration = motionDetector.xAcceleration
        //let yAcceleration = motionDetector.yAcceleration
        //let zAcceleration = motionDetector.zAcceleration
        
        speedX = speedX + Int(xAcceleration * (currentTime - prevTime))
        
        print("xAcceleration: \(xAcceleration)")
        print("speedX: \(speedX)")
        print("prevTime: \(prevTime)")
        print("currentTime: \(currentTime)")
        return speedX
    }
     
    
    //Einzelne Striche
    func tick(at tick: Int, totalTicks: Int) -> some View {
        //let percent = (tick * 100) / totalTicks
        let startAngle = coveredRadius/2 * -1
        let stepper = coveredRadius/Double(totalTicks)
        let rotation = Angle.degrees(startAngle + stepper * Double(tick))
        return VStack {
                   Rectangle()
                    //.fill(colorMix(percent: percent))
                       .frame(width: tick % 2 == 0 ? 5 : 3,
                              height: tick % 2 == 0 ? 20 : 10) //alternet small big dash
                   Spacer()
           }.rotationEffect(rotation)
    }
    
    //Einzelne Texte
    func tickText(at tick: Int, text: String) -> some View {
            //let percent = (tick * 100) / tickCount
            let startAngle = coveredRadius/2 * -1 + 90
        let stepper = coveredRadius/Double(tickCount)
        let rotation = startAngle + stepper * Double(tick)
        return Text(text).rotationEffect(.init(degrees: -1 * rotation), anchor: .center).offset(x: -115, y: 0).rotationEffect(Angle.degrees(rotation))
    }
    
    
    private var tickCount: Int {
        return maxValue/steperSplit
    }
    
    func getAngle(value: Double) -> Double {
        return (value/Double(maxValue))*coveredRadius - coveredRadius/2 + 90
    }
    
    //@Binding var value: Double
    
    var body: some View {
        ZStack {
            Text("\(speed, specifier: "%0.0f")")
                .font(.system(size: 40, weight: Font.Weight.bold))
                .foregroundColor(.accentColor)
                .offset(x: 0, y: 40)
            ForEach(0..<tickCount*2 + 1, id:\.self) { tick in
                self.tick(at: tick,
                          totalTicks: self.tickCount*2)
            }
            ForEach(0..<tickCount+1, id:\.self) { tick in
                self.tickText(at: tick, text: "\(self.steperSplit*tick)")
            }
            Needle()
                .foregroundColor(.accentColor)
                .frame(width: 140, height: 6)
                .offset(x: -70, y: 0)
                .rotationEffect(.init(degrees: getAngle(value: Double(speed))), anchor: .center)
                .animation(.linear, value: speed)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.accentColor)
        }.frame(width: 300, height: 300, alignment: .center)
        
        .navigationTitle("Tachometer")
    }
}

struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}


struct TachometerView_Previews: PreviewProvider {
    @StateObject static var detector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        TachometerView()
            .environmentObject(detector)
    }
}


