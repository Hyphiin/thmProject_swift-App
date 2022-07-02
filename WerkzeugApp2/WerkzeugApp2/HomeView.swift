//
//  ContentView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: KompassView())
                {
                    ButtonView(text: "Kompass")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: WasserwaageView())
                {
                    ButtonView(text: "Wasserwaage")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: TachometerView())
                {
                    ButtonView(text: "Tachometer")
                }
                .buttonStyle(LinkStyle())
                NavigationLink(destination: SeismometerView())
                {
                    ButtonView(text: "Seismometer")
                }
                .buttonStyle(LinkStyle())
                
                    
            }            
            .navigationTitle("Home")
        }
        .background(Color.yellow)
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
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange,Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
