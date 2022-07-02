//
//  ContentView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CircleNumberView(color: .red, number: 1)
    }
}

struct CircleNumberView: View {
    var color: Color
    var number: Int
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
            Text("\(number)")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .bold))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
