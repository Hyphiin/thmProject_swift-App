//
//  ContentView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct HomeView: View {
    
    @State static private var detector = MotionDetector(updateInterval: 0.01).started()
    
    var body: some View {
        
        NavigationView{
            ScrollView {
                VStack{
                    HStack{
                        NavigationLink(destination: KompassView())
                        {
                            CardView(
                                iconName: "location.north.circle",
                                title: "Kompass"
                            )
                           
                        }
                        NavigationLink(destination: WasserwaageView().environmentObject(HomeView.detector))
                        {
                            CardView(
                                iconName: "circle.and.line.horizontal",
                                title: "Wasserwaage"
                            )
                        }
                    }.padding(.horizontal, 10)
                    HStack{
                        NavigationLink(destination: SeismometerView().environmentObject(HomeView.detector))
                        {
                            CardView(
                                iconName: "iphone.radiowaves.left.and.right",
                                title: "Seismometer"
                            )
                        }
                        NavigationLink(destination: StepcounterView().environmentObject(HomeView.detector))
                        {
                            CardView(
                                iconName: "figure.walk",
                                title: "Schrittzähler"
                            )
                        }                        
                    }.padding(.horizontal, 10)
                    HStack{
                        NavigationLink(destination: RechnerView())
                        {
                            CardView(
                                iconName: "plus.forwardslash.minus",
                                title: "Rechner"
                            )
                        }
                        NavigationLink(destination: TaschenlampeView())
                        {
                            CardView(
                                iconName: "flashlight.on.fill",
                                title: "Taschenlampe"
                            )
                        }
                    }.padding(.horizontal, 10)
                    HStack{
                        NavigationLink(destination: TachometerView().environmentObject(HomeView.detector))
                        {
                            CardView(
                                iconName: "gauge",
                                title: "Tachometer"
                            )
                        }
                        NavigationLink(destination: Text("Coming soon"))
                        {
                            CardView(
                                iconName: "questionmark.circle",
                                title: "..."
                            )
                        }
                    }.padding(.horizontal, 10)
                }
            }
            .navigationTitle("Home")
            .background(Color.ui.backgroundColor)
        }
       
    }
       
        
}

struct CardView: View {
    var iconName: String
    var title: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: iconName)
                .font(.system(size: 60))
                .foregroundColor(Color.ui.accentColor)
            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(Color.ui.primaryText)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 250)
        .background(Color.ui.backgroundColorCard)
        .padding(10)
        .cornerRadius(40)
        .shadow(color: Color.ui.shadow, radius: 6, x: 2, y: 2)
        
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
         let primaryText = Color("PrimaryText")
         let backgroundColor = Color("backgroundColor")
         let backgroundColorCard = Color("backgroundColorCard")
         let shadow = Color("Shadow")
    }
}


struct HomeView_Previews: PreviewProvider {
    @StateObject static private var motionDetector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        HomeView()
            .environmentObject(motionDetector)
    }
}
