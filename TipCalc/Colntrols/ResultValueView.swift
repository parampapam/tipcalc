//
//  ResultValueView.swift
//  TipCalc
//
//  Created by Роман Поспелов on 10.11.2020.
//

import SwiftUI

struct ResultValueView: View {
    
    let title: String
    let value: String
    
    @Binding private var tooltipText: String?
        
    var body: some View {
        VStack {
            Text("\(title)")
                .font(.headline)
                .padding(.bottom, 1)
            Text("\(value)")
                .font(.title2)
                .onTapGesture {
                    UIPasteboard.general.string = value
                    withAnimation {
                        tooltipText = "\(value) copied to clipboard"
                    }
                }
        }
        .padding(.top, 10)
        .foregroundColor(.labelForeground)
    }
    
    init(_ title: String, value: String, tooltipText: Binding<String?>? = nil) {
        self.title = title
        self.value = value
        self._tooltipText = tooltipText ?? Binding.constant(nil)
    }
}

struct ResultValueView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultValueView("Total Amount", value: "$10,000.00")
                .environment(\.colorScheme, .light)
            ResultValueView("Total Amount", value: "$10,000.00")
                .background(Color.mainGradient[0])
                .environment(\.colorScheme, .dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
