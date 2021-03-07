//
//  TipCalcViewModel.swift
//  TipCalc
//
//  Created by Роман Поспелов on 09.11.2020.
//
//  MVVM pattern: view model.
//

import SwiftUI
import Combine


class TipCalcViewModel: ObservableObject {

    // The formatter for converting amount from Double to String
    private(set) var amountFormatter: NumberFormatter

    // The MVVM pattern Data Model for calculation the tip and others amounts. This var is private
    // since the View should not be access it. But it's published because when the Data Model changes,
    // the View should update.
    @Published private var model = TipCalcModel()

    // Device orientation flag. The View should only read this value.
    @Published private(set) var isPortrait: Bool = true

    // A message to display in the tooltip area ont top of the View.
    @Published var tooltipText: String?
    
    private var observer: NSObjectProtocol?
    
    private var toolTipSubscriber : AnyCancellable?
    
    var billAmount: Double? {
        get {
            model.invoiceAmount
        }
        set {
            model.invoiceAmount = newValue ?? 0
        }
    }
    
    var tipFactor: Double {
        get {
            model.tipFactor
        }
        set {
            model.tipFactor = newValue
        }
    }
    
    var countOfPersons: Double {
        get {
            Double(model.countOfPersons)
        }
        set {
            model.countOfPersons = Int(newValue)
        }
    }
    
    var tipAmount: String {
        getAmountString(model.tipAmount)
    }
    
    var totalAmount: String {
        getAmountString(model.totalAmount)
    }
    
    var tipAmountPerPerson: String {
        getAmountString(model.tipAmountPerPerson)
    }
    
    var totalAmountPerPerson: String {
        getAmountString(model.totalAmountPerPerson)
    }

    func getAmountString(_ value: Double) -> String {
        amountFormatter.string(from: NSNumber(value: value)) ?? "--"
    }
  
    init() {
        amountFormatter = NumberFormatter()
        amountFormatter.locale = Locale.current
        amountFormatter.numberStyle = .currency
        amountFormatter.currencyCode = nil
        amountFormatter.isLenient = true
        
        observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil)
            { [unowned self] note in
                guard let device = note.object as? UIDevice else {
                    return
                }
                if device.orientation.isValidInterfaceOrientation {
                    isPortrait = device.orientation.isPortrait
                }
            }
        
        toolTipSubscriber = $tooltipText.sink {
            if $0 != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.tooltipText = nil
                    }
                }
            }
        }
    }

    deinit {
        if let o = observer {
            NotificationCenter.default.removeObserver(o)
        }
    }
}
