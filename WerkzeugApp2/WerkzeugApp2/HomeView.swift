//
//  ContentView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01).started()
    
    var body: some View {
        
        NavigationView{
            VStack{
                NavigationLink(destination: KompassView())
                {
                    ButtonView(text: "Kompass")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: WasserwaageView().environmentObject(HomeView.detector))
                {
                    ButtonView(text: "Wasserwaage")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: TachometerView().environmentObject(HomeView.detector))
                {
                    ButtonView(text: "Tachometer")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: SeismometerView().environmentObject(HomeView.detector))
                {
                    ButtonView(text: "Seismometer")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: Text({"Taschenlampe"}()))
                {
                    ButtonView(text: "Taschenlampe")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: Text({"Rechner"}()))
                {
                    ButtonView(text: "Rechner")
                }
                .buttonStyle(LinkStyle())
                
                    
            }            
            .navigationTitle("Home")
        }  
       
    }
       
        
}

struct ButtonView: View {
    var text: String
    var body: some View {
        HStack{
            Text(text)
                .fontWeight(.semibold)
                .font(.title)
        }
    }
}

struct LinkStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.ui.primaryDark, Color.ui.primaryLight]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension Color {
    static let ui = Color.UI()
    
    struct UI {
         let accentColor = Color("AccentColor")
         let primaryDark = Color("PrimaryDark")
         let primaryLight = Color("PrimaryLight")
         let secondaryDark = Color("SecondaryDark")
         let secondaryLight = Color("SecondaryLight")
    }
}


struct ContentView_Previews: PreviewProvider {
    @StateObject static private var motionDetector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        HomeView()
            .environmentObject(motionDetector)
    }
}
