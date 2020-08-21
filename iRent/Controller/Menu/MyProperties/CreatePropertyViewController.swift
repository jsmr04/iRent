//
//  CreatePropertyViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-20.
//  Copyright © 2020 Jose Smith Marmolejos & Arthur Ataide. All rights reserved.
//

import UIKit

class CreatePropertyViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var photoFloatingButton: UIButton!
    
    var types = ["Apartment", "House", "Basement"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        typePickerView.delegate = self
        
        photoFloatingButton.backgroundColor = UIColor(named: "RedMain")
        photoFloatingButton.layer.cornerRadius = photoFloatingButton.frame.height / 2
    }
    
    @IBAction func photoFloatingClicked(_ sender: UIButton) {
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITextView

extension CreatePropertyViewController: UITextViewDelegate {
    func setUpTextView(){
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.text = "Describe your property..."
        descriptionTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray.withAlphaComponent(0.6) {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Describe your property..."
            descriptionTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
    }
}

//MARK: - UIPickerView

extension CreatePropertyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
