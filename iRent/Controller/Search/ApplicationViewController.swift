//
//  ApplicationViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-24.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class ApplicationViewController: UIViewController {

    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offerTextField: UITextField!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var applyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        // Do any additional setup after loading the view.
        applyButton.setImage(nil, for: .normal)
        applyButton.setTitle("Continue", for: .normal)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonClicked(_ sender: UIButton) {
        print(applyButton.titleLabel?.text)
        if(applyButton.titleLabel?.text == "Continue"){
            performSegue(withIdentifier: "DocumentsRequestSegue", sender: nil)
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
       let _ = self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITextView

extension ApplicationViewController: UITextViewDelegate {
    func setUpTextView(){
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        commentTextView.text = "Leave a comment to the owner..."
        commentTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.textColor == UIColor.lightGray.withAlphaComponent(0.6) {
            commentTextView.layer.borderColor = UIColor(named: "RedMain")?.withAlphaComponent(0.6).cgColor
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty {
            commentTextView.text = "Leave a comment to the owner..."
            commentTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
            commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        }
    }
}
