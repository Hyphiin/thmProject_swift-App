//
//  RechnerView.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import SwiftUI

struct RechnerView: View {
    
    let grid = [
        ["AC","⌦","%","/"],
        ["7","8","9","*"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        [".","0","","="]
    ]

    let operators = ["/","+","*","-","%"]

    //Eingabe(Rechnung), die über dem Ergebnis angezeigt wird
    @State var visibleWorkings = ""
    //Ergebnis, dass angezeigt wird
    @State var visibleResults = ""
    //bei Falscheingabe z.B. "-="
    @State var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                //Eingabe
                Text(visibleWorkings)
                    .padding()
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(Color.ui.primaryText)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                Spacer()
                //Ergebnis
                Text(visibleResults)
                    .padding()
                    .font(.system(size: 50, weight: .heavy))
                    .foregroundColor(Color.ui.primaryText)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            //Felder, erstellt aus dem grid
            ForEach(grid, id: \.self){
                row in
                HStack{
                    ForEach(row, id: \.self){
                        cell in
                        Button(action: { buttonPressed(cell: cell)}, label: {
                            Text(cell)
                                .foregroundColor(buttonColor(cell))
                                .font(.system(size: 40, weight: .heavy))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                    }
                }
            }
        }
        //Benachrichtigung bei Falscheingabe
        .alert(isPresented: $showAlert){
            Alert(title: Text("Ungültige Eingabe"),
                  message: Text(visibleWorkings),
                  dismissButton: .default(Text("Okay")))
        }
        
        .navigationTitle("Taschenrechner")
    }

    //Hilfsfunktion, um Operatoren besonders einzufärben
    func buttonColor(_ cell: String) -> Color {
        if(cell == "AC" || cell == "⌦"){
            return .red
        }
        if(cell == "-" || cell == "=" || operators.contains(cell)){
            return Color.ui.accentColor
        }
        
        return Color.ui.primaryText
    }
    
    //wird aufgerufen, wenn ein Button im grid Feld gedrückt wird
    //je nach cell-value wird andere Operation vorgenommen
    func buttonPressed(cell: String)  {
        switch cell {
        case "AC":
            //alles löschen
            visibleWorkings = ""
            visibleResults = ""
        case "⌦":
            //letztes Element in EingabeString löschen
            visibleWorkings = String(visibleWorkings.dropLast())
        case "=":
            //Ergebnis ausrechnen
            visibleResults = calcResults()
        case "-":
            //Minus einfügen
            addMinus()
        case "*","/","%","+":
            //Operator einfügen
            addOperator(cell)
        default:
            //Bei Eingabe einer Zahl = EingabeString plus diese Zahl
            visibleWorkings += cell
        }
    }
    
    func addOperator(_ cell: String) {
        if !visibleWorkings.isEmpty{
            let last =  String(visibleWorkings.last!)
            if operators.contains(last) || last == "-" {
                visibleWorkings.removeLast()
            }
            visibleWorkings += cell
        }
    }
    func addMinus() {
        if visibleWorkings.isEmpty || visibleWorkings.last! != "-"{
            visibleWorkings += "-"
        }
    }
    
    func calcResults() -> String {
        if(validInput()){
            //%-Zeichen wird mit *0.01 ersetzt
            let workings  = visibleWorkings.replacingOccurrences(of: "%", with: "*0.01")
            //NSExpression wandelt String(workings) in Mathematische Funktion um
            let expression = NSExpression(format: workings)
            let result =  expression.expressionValue(with: nil, context: nil) as! Double
            
            return formatResults(val: result)
        }
        showAlert = true
        return ""
    }
    //schaut ob Eingabe korrekt ist (nicht leer, letztes Element kein Operator, ".")
    func validInput() -> Bool {
        if(visibleWorkings.isEmpty){
            return false
        }
        let last = String(visibleWorkings.last!)
        if(operators.contains(last) || last == "-"){
            if(last != "%" || visibleWorkings.count == 1){
                return false
            }
        }
        if last == "."{
            return false
        }
        return true
    }
    func formatResults(val: Double) -> String {
        if(val.truncatingRemainder(dividingBy: 1) == 0){
            return String(format: "%.0f", val)
        }
        return String(format: "%.2f", val)
    }
}


struct RechnerView_Previews: PreviewProvider {
    
    static var previews: some View {
        RechnerView()
    }
}



