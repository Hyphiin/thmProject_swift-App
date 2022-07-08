//
//  KompassView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct KompassView: View {
    @ObservedObject var compassHeading = KompassLogik()
    
    var body: some View {
        VStack{
            Capsule()
                .frame(width: 5, height: 50)
            ZStack{
                ForEach(Marker.markers(), id:\.self) {
                    marker in CompassMarkerView(marker: marker, compassDegrees: 0)
                }
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
            .statusBar(hidden: true)
            Text("Grad: " + String(self.compassHeading.degrees * -1) + "°")
                .fontWeight(.semibold)
                .padding()
        
        }
        .navigationTitle("Kompass")
    }
}

struct Marker: Hashable {
    let degrees: Double
    let lable: String
    
    init(degrees: Double, lable: String = ""){
        self.degrees = degrees
        self.lable = lable
    }
    
    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, lable: "S"),
            Marker(degrees: 30, lable: ""),
            Marker(degrees: 60, lable: ""),
            Marker(degrees: 90, lable: "W"),
            Marker(degrees: 120, lable: ""),
            Marker(degrees: 150, lable: ""),
            Marker(degrees: 180, lable: "N"),
            Marker(degrees: 210, lable: ""),
            Marker(degrees: 240, lable: ""),
            Marker(degrees: 270, lable: "E"),
            Marker(degrees: 300, lable: ""),
            Marker(degrees: 330, lable: ""),
        ]
    }
    
    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }
}

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegrees: Double
    
    var body: some View {
        VStack {
            Text(marker.degreeText())
                .fontWeight(.light)
                .rotationEffect(self.textAngle())
            Capsule()
                .frame(width: self.capsuleWidth(), height: self.capsuleHeight())
                .foregroundColor(self.capsuleColor())
                .padding(.bottom, 120)
            Text(marker.lable)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 80)
        }
        .rotationEffect(Angle(degrees: marker.degrees))
        
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 7 : 3
    }
    
    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }
    
    private func capsuleColor() -> Color {
        return self.marker.degrees == 0 ? .accentColor : .gray
    }
    
    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegrees - self.marker.degrees)
    }
    
}
