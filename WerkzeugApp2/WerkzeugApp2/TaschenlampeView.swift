//
//  TaschenlampeView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI
import AVFoundation

struct TaschenlampeView: View {
    
    @State var toggleOn = false
    
    var cardIcon: String {
        var iconName = ""
        if toggleOn {
            iconName = "flashlight.on.fill"
        } else {
            iconName = "flashlight.off.fill"
        }
        return iconName
    }
    
    var cardTitle: String {
        var title = ""
        if toggleOn {
            title = "Aus"
        } else {
            title = "An"
        }
        return title
    }
    
    func toggleTorch() {
        toggleOn = !toggleOn
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if toggleOn == true {
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
                    Button(action: { toggleTorch()}){
                        CardView(
                            iconName: cardIcon,
                            title: cardTitle
                        )
                       
                    }
                    
                    
                }.padding()
            }
        }
        .navigationTitle("Taschenlampe")
        .frame(minWidth: 400, minHeight: 1500)
        .background(toggleOn ? .white : .black)
        .padding(.top,30)
    }
        
}

struct TaschenlampeView_Previews: PreviewProvider {
    static var previews: some View {
        TaschenlampeView()
    }
}
