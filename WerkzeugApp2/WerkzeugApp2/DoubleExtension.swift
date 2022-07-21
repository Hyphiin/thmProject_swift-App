//
//  DoubleExtension.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 03.07.22.
//

import Foundation

//Erweiterung von Double, um diese einfach als String im Format "+00.00" o."-00.00" anzeigen zu lassen
extension Double {
    func describeAsFixedLengthString(integerDigits: Int = 2, fractionDigits: Int = 2) -> String {
        self.formatted(
            .number
                .sign(strategy: .always())
                .precision(
                    .integerAndFractionLength(integer: integerDigits, fraction: fractionDigits)
                )
        )
    }
}
