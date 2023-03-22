//
//  FirstViewController.swift
//  CurrencyConverter
//
//  Created by 이송은 on 2023/03/06.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var USDTextfield: UITextField!
    @IBOutlet weak var selectedCurrencyName: UILabel!
    @IBOutlet weak var selectedCurrencyTextField: UITextField!
    @IBOutlet weak var UpdateTimeLabel: UILabel!
    
    var rates : [(String, Double)]?
    var selectedRow = 0 {
        didSet{
            selectedCurrencyName.text = rates?[selectedRow].0
            selectedCurrencyTextField.text = calculateCurrency()
        }
    }
    func calculateCurrency() -> String {
        let selectedValue = rates?[selectedRow].1 ?? 0
        let USDValue = Double(USDTextfield.text ?? "") ?? 0
        
        let resultValue = String(format: "%.2f", (selectedValue * USDValue))
        //        return (selectedValue * USDValue).description
        return resultValue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        USDTextfield.delegate = self
        
        fetchJson()
    }
    
    func fetchJson(){
        
        NetworkLayer.fetchJson{ model in
            self.rates = model.rates.sorted { $0.key < $1.key }
            DispatchQueue.main.async {
                self.currencyPicker.reloadAllComponents()
                self.UpdateTimeLabel.text = model.lastUpdate
                
            }
            
        }
    }
}

extension FirstViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rates?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key = rates?[row].0 ?? ""
        let value = rates?[row].1.description ?? ""
        
        return key + "  " + value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    
    }
}

extension FirstViewController : UITextFieldDelegate {
    //값 변경할 때 마다 상태 업데이트
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedCurrencyTextField.text = calculateCurrency()
    }
}
