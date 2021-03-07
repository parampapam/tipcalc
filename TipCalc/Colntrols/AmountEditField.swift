//
//  AmountEditField.swift
//  TipCalc
//
//  Created by Роман Поспелов on 13.11.2020.
//

import SwiftUI
import Combine


struct AmountEditField: View {
    let label: LocalizedStringKey

    @Binding var value: Double?

    private let formatter: NumberFormatter

    private let editFormatter: NumberFormatter

    @State private var textValue: String = ""

    @State private var hasInitialTextValue = false

    @State private var showHideKeyboardButton = false

    var body: some View {
        HStack {
            TextField(label, text: $textValue, onEditingChanged: { isInFocus in
                let newValue = formatter.number(from: textValue)
                let newTextValue = (isInFocus ? editFormatter.string(for: newValue) : formatter.string(for: newValue)) ?? ""
                textValue = newTextValue == "0" ? "" : newTextValue
                showHideKeyboardButton = isInFocus
            })
                    .onReceive(Just(textValue)) {
                        guard self.hasInitialTextValue else {
                            return
                        }
                        // This is the only place we update `value`.
                        if let newValue = formatter.number(from: $0)?.doubleValue, newValue != self.value {
                            self.value = newValue
                        }

                    }
                    .onAppear() { // Otherwise text field is empty when view appears
                        hasInitialTextValue = true
                        // Any `textValue` from this point on is considered valid and
                        // should be synced with `value`.
                        if let value = self.value {
                            self.textValue = formatter.string(from: NSNumber(value: value)) ?? ""
                        }
                    }
                    .keyboardType(.decimalPad)

            if showHideKeyboardButton {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    showHideKeyboardButton = false
                }) {
                    Image(systemName: "return")
                        .padding(2)
                        .shadow(radius: 2)
                }
            }
        }
    }

    init(_ label: LocalizedStringKey, value: Binding<Double?>, formatter: NumberFormatter) {
        self.label = label
        self._value = value
        self.formatter = formatter

        // Configure the edit string formatter to behave like the input
        // formatter without add the currency symbol
        self.editFormatter = NumberFormatter()
        self.editFormatter.allowsFloats = formatter.allowsFloats
        self.editFormatter.alwaysShowsDecimalSeparator = formatter.alwaysShowsDecimalSeparator
        self.editFormatter.decimalSeparator = formatter.decimalSeparator
        self.editFormatter.maximumIntegerDigits = formatter.maximumIntegerDigits
        self.editFormatter.maximumSignificantDigits = formatter.maximumSignificantDigits
        self.editFormatter.maximumFractionDigits = formatter.maximumFractionDigits
        self.editFormatter.multiplier = formatter.multiplier
    }
}


struct AmountEditField_Previews: PreviewProvider {
    
    @State static private var amount: Double? = 199.85
    
    static var previews: some View {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.currencyCode = nil
        formatter.isLenient = true
        
      
        return AmountEditField("Amount", value: $amount, formatter: formatter)
            .environment(\.colorScheme, .light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
