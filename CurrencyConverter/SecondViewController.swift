//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by 이송은 on 2023/03/06.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var USDTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var rates : [(String, Double)]?
    var USDvalue : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        USDTF.delegate = self
        fetchJson()
        
        
    }

    func fetchJson(){
        NetworkLayer.fetchJson { model in
            self.rates = model.rates.sorted { $0.key < $1.key }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension SecondViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConcurrencyCell", for: indexPath) as? ConcurrencyCell else { return UITableViewCell() }
        
        cell.NameLB.text = rates?[indexPath.row].0.description
        
        let changedValue = (self.rates?[indexPath.row].1 ?? 0) * Double(USDvalue ?? 0)
        let resultValue =  String(format: "%.2f", changedValue)
        cell.MoneyLB.text = resultValue
       
        return cell
    }
    
   
    
    
}
extension SecondViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        USDvalue = Double(USDTF.text ?? "")
        tableView.reloadData()
    }
}

class ConcurrencyCell : UITableViewCell {
    
    @IBOutlet weak var NameLB: UILabel!
    @IBOutlet weak var MoneyLB: UILabel!
}

