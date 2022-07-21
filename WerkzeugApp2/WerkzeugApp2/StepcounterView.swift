//
//  StepcounterView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 20.07.22.
//

import SwiftUI
import CoreMotion

struct StepcounterView: View {
    @EnvironmentObject var motionDetector: MotionDetector
    
    var body: some View {
        VStack{
            Text(motionDetector.steps != nil ? "Steps: \(motionDetector.steps!)" : "Keine Schrittdaten vorhanden")
        }
        .navigationTitle("Schrittzähler")
    }
}

struct StepcounterView_Previews: PreviewProvider {
    @StateObject static var detector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        StepcounterView().environmentObject(detector)
    }
}
