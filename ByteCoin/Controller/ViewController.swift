//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currenyPicker: UIPickerView!
    @IBOutlet weak var searchTextField: UITextField!
    var currentRow = 0
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                coinManager.delegate = self
        currenyPicker.dataSource = self
        currenyPicker.delegate = self
        searchTextField.delegate = self
    }

}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
        currentRow = row
        
    }
    
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdateRate(_ coinManager: CoinManager, coinModel: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(coinModel.rate)
            self.currencyLabel.text = coinModel.quote
            
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate{
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            searchTextField.placeholder = "Search"
            return true
        }
        else
        {
            textField.placeholder = "Please enter valid coin"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let coin = searchTextField.text{
            coinManager.changeBaseUrl(to: coin)
        }
        print(currentRow)
        coinManager.getCoinPrice(for: coinManager.currencyArray[currentRow])
        currenyPicker.selectRow(currentRow, inComponent: 0, animated: true)
        searchTextField.text = ""
    }
}
