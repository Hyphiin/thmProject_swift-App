//
//  TaschenlampeView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI
import AVFoundation

struct TaschenlampeView: View {
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: { toggleTorch(on: true)}){
                        Image(systemName: "flashlight.off.fill")
                            .foregroundColor(Color.ui.accentColor)
                    } 
                    Button(action: { toggleTorch(on: false) }){
                        Image(systemName: "flashlight.on.fill")
                            .foregroundColor(Color.ui.accentColor)
                    }
                }.padding()
            }
        }
        .navigationTitle("Taschenlampe")
    }
}

struct TaschenlampeView_Previews: PreviewProvider {
    static var previews: some View {
        TaschenlampeView()
    }
}
