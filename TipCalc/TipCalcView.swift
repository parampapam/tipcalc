//
//  ContentView.swift
//  TipCalc
//
//  Created by Роман Поспелов on 09.11.2020.
//

import SwiftUI

struct TipCalcView: View {
    
    @ObservedObject private var model = TipCalcViewModel()
    
    @State private var showCopiedToClipboardTooltip = false
    
    var body: some View {
        ZStack(alignment: .top ) {
            // The view consists of two areas: for entering parameters for calculations and for output
            // of the calculations result. Depending on the device orientation, the areas will be
            // horizontal or vertical.
            if model.isPortrait {
                VStack {
                    inputBody()
                    Spacer()
                    resultBody()
                }
            } else {
                HStack {
                    inputBody()
                    Divider()
                    resultBody()
                }
            }

            // At the top, a message will appear about copying the value to the clipboard.
            if let tooltipText = model.tooltipText {
                HStack {
                    Spacer()
                    Text(tooltipText)
                        .font(.caption2)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 8)
                        .foregroundColor(Color.tooltipForeground)
                        .background(Color.tooltipBackground.shadow(radius: 5))
                        .cornerRadius(5)
                    Spacer()
                }
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding()
        .background(background())
    }

    // Creating the view for entering parameters for calculation
    func inputBody() -> some View {
        VStack {
            Text("Tip Calculator")
                    .font(.largeTitle)
                    .padding(.bottom)

            VStack {
                Text("To the bill for the amount")
                    .font(.subheadline)
                    .foregroundColor(.labelForeground)
                AmountEditField("Amount", value: $model.billAmount, formatter: model.amountFormatter)
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .foregroundColor(Color.textFieldForeground)
                    .background(Color.textFieldBackground.shadow(radius: 2.0))
                    .animation(.easeInOut(duration: 0.2))

                Text(model.tipFactor > 0 ? "Add \(Int(model.tipFactor * 100))% tip" : "No add tip")
                    .font(.subheadline)
                    .foregroundColor(.labelForeground)
                    .padding(.top, 20)
                Slider(value: $model.tipFactor, in: 0...1, step: 0.05)
                    .accentColor(.sliderAccent)

                Text(model.countOfPersons > 1 ? "And divide by \(Int(model.countOfPersons)) persons" : "And not divide")
                    .font(.subheadline)
                    .foregroundColor(.labelForeground)
                    .padding(.top, 20)
                Slider(value: $model.countOfPersons, in: 1...15, step: 1)
                    .accentColor(.sliderAccent)

            }
        }
    }

    // Creating the view for outputting of the calculation result
    func resultBody() -> some View {
        ScrollView {
            ResultValueView("Tip:", value: model.tipAmount, tooltipText: $model.tooltipText)
            ResultValueView("Tip per person:", value: model.tipAmountPerPerson, tooltipText: $model.tooltipText)
            ResultValueView("Total amount (bill + tip):", value: model.totalAmount, tooltipText: $model.tooltipText)
            ResultValueView("Total amount per person:", value: model.totalAmountPerPerson, tooltipText: $model.tooltipText)
        }
    }

    // View for creating the app main background
    func background() -> some View {
        GeometryReader { geometry in
            RadialGradient(gradient: Gradient(colors: Color.mainGradient),
                           center: .bottom,
                           startRadius: min(geometry.size.width, geometry.size.height) * 0.1,
                           endRadius: min(geometry.size.width, geometry.size.height) * 1.3)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TipCalcView()
//            .environment(\.colorScheme, .dark)
    }
}
