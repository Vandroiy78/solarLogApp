//
//  ViewController.swift
//  solarLogApp
//
//  Created by Holger Preu on 25.03.21.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var totalPowerLabel: UILabel!
    @IBOutlet weak var pdcLabel: UILabel!
    @IBOutlet weak var yieldDayLabel: UILabel!
    @IBOutlet weak var yieldYesterdayLabel: UILabel!
    @IBOutlet weak var yieldMonthLabel: UILabel!
    @IBOutlet weak var yieldYearLabel: UILabel!
    @IBOutlet weak var yieldTotalLabel: UILabel!
    
    @IBOutlet weak var consPacLabel: UILabel!
    @IBOutlet weak var consYieldDayLabel: UILabel!
    @IBOutlet weak var consYieldYesterdayLabel: UILabel!
    @IBOutlet weak var consYieldMonthLabel: UILabel!
    @IBOutlet weak var consYieldYearLabel: UILabel!
    @IBOutlet weak var consYieldTotalLabel: UILabel!
    
    @IBOutlet weak var balancePdcLabel: UILabel!
    @IBOutlet weak var balanceDayLabel: UILabel!
    @IBOutlet weak var balanceYesterdayLabel: UILabel!
    @IBOutlet weak var balanceMonthLabel: UILabel!
    @IBOutlet weak var balanceYearLabel: UILabel!
    @IBOutlet weak var balanceTotalLabel: UILabel!
    
    
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        model.getSolarData()
    }
    @IBOutlet weak var balanceView: GaugeView!
    
    @IBOutlet weak var totalPowerView: GaugeView!
    
    
    var model = SolarDataModel()
    var solarLogAddress:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        model.delegate = self
        model.getSolarData()
        
        totalPowerView.backgroundColor = .clear
        balanceView.backgroundColor = .clear
        
        totalPowerView.outerBezelColor = UIColor(red: 0.11, green: 0.66, blue: 0, alpha: 1.0)
        totalPowerView.innerBezelColor = UIColor(red: 0.42, green: 0.75, blue: 0, alpha: 1.0)
        
        balanceView.outerBezelColor = UIColor(red: 0.66, green: 0.46, blue: 0, alpha: 1.0)
        balanceView.innerBezelColor = UIColor(red: 0.83, green: 0.6, blue: 0, alpha: 1.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            }


}

extension ViewController: SolarDataProtocol {
    func solarDataRetrieved(_ data: Welcome) {
        // here it goes
        
        let myData = data.the801.the170
        printPowerValue(totalPowerLabel, "Installiert", myData.totalPower, "Wp")
        
        // Yield
        printPowerValue(pdcLabel, "Jetzt", myData.pdc, "W")
        printPowerValue(yieldDayLabel, "Heute", myData.yieldDay, "Wh")
        printPowerValue(yieldYesterdayLabel, "Gestern", myData.yieldYesterday, "Wh")
        printPowerValue(yieldMonthLabel, "Monat", myData.yieldMonth, "Wh")
        printPowerValue(yieldYearLabel, "Jahr", myData.yieldYear, "Wh")
        printPowerValue(yieldTotalLabel, "Gesamt", myData.yieldTotal, "Wh")
        
        // Consumption
        printPowerValue(consPacLabel, "Jetzt", myData.consPac, "W")
        printPowerValue(consYieldDayLabel, "Heute", myData.consYieldDay, "Wh")
        printPowerValue(consYieldYesterdayLabel, "Gestern", myData.consYieldYesterday, "Wh")
        printPowerValue(consYieldMonthLabel, "Monat", myData.consYieldMonth, "Wh")
        printPowerValue(consYieldYearLabel, "Jahr", myData.consYieldYear, "Wh")
        printPowerValue(consYieldTotalLabel, "Gesamt", myData.consYieldTotal, "Wh")
        
        // Balance
        printBalance(balancePdcLabel, yield: myData.pdc, cons: myData.consPac, unit: "W")
        printBalance(balanceDayLabel, yield: myData.yieldDay, cons: myData.consYieldDay, unit: "Wh")
        printBalance(balanceYesterdayLabel, yield: myData.yieldYesterday, cons: myData.consYieldYesterday, unit: "Wh")
        printBalance(balanceMonthLabel, yield: myData.yieldMonth, cons: myData.consYieldMonth, unit: "Wh")
        printBalance(balanceYearLabel, yield: myData.yieldYear, cons: myData.consYieldYear, unit: "Wh")
        printBalance(balanceTotalLabel, yield: myData.yieldTotal, cons: myData.consYieldTotal, unit: "Wh")
        
        // Update timestamp
        lastUpdatedLabel.text = "Daten von: \(myData.lastUpdateTime)"
        
        // Show current power
        var currentPowerPercent: Int
        if myData.totalPower == 0 {
            currentPowerPercent = 0
        }
        else {
            currentPowerPercent = Int((Double(myData.pdc) / Double(myData.totalPower)) * 100 )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 1) {
                self.totalPowerView.value = currentPowerPercent
            }
        }
        
        var currentBalance: Int
        
        if myData.consPac == 0 {
            currentBalance = 100
        }
        else {
            let currentBalanceTemp = (Double(myData.pdc) / Double(myData.consPac)) * 50
            
            if currentBalanceTemp > 100 {
                currentBalance = 100
            }
            else {
                currentBalance = Int(currentBalanceTemp)
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 1) {
                self.balanceView.value = currentBalance
                self.balanceView.valueLabel.text = "-"
            }
        }
    }
    
    func prettyPrint(_ number:Int, _ unit:String) -> String {
        
        var myReturn: String
        
        if abs(number) < 1000 {
            myReturn = String("\(number) \(unit)")
        }
        else if abs(number) < 1000000 {
            let roundedNumber = (Double(number)/1000.0 * 100).rounded() / 100
            myReturn = String("\(roundedNumber) k\(unit)")
        }
        else {
            let roundedNumber = (Double(number)/1000000.0 * 100).rounded() / 100
            myReturn = String("\(roundedNumber) M\(unit)")
        }
        
        return myReturn
    }
    
    func printPowerValue(_ label:UILabel, _ prefix:String, _ value:Int, _ unit:String) {
        label.text = "\(prefix): \(prettyPrint(value, unit))"
    }
    
    func printBalance(_ label:UILabel, yield:Int, cons:Int, unit:String) {
        var balance:Int
        balance = yield - cons
        label.text = prettyPrint(balance, unit)
        if balance >= 0 {
            label.textColor = UIColor(red: 0, green: 0.7, blue: 0.2, alpha: 1.0)
        }
        else {
            label.textColor = .red
        }
    }
    
}
