//
//  CreatePropertyViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-20.
//  Copyright © 2020 Jose Smith Marmolejos & Arthur Ataide. All rights reserved.
//

import UIKit
import FirebaseAuth

struct ImageData {
    var mediaId:String
    var image:UIImage
    var imageString:String
}

class CreatePropertyViewController: UIViewController {
    let cellIdentifer = "PhotoView"
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var photoFloatingButton: UIButton!
    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var types = ["Apartment", "House", "Basement", "Shared room"]
    
    fileprivate var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "CellIdentifer")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //propertyToLogin
        setUpTextView()
        typePickerView.delegate = self
        title = "Post Property"
        
        //TODO: Fix the size issue in the collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //imageCollectionView.collectionViewLayout = layout
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellIdentifer)
        imageCollectionView.frame = .zero
        
        view.addSubview(imageCollectionView)
        view.sendSubviewToBack(imageCollectionView)
        
        imageCollectionView.backgroundColor = .white
        imageCollectionView.topAnchor.constraint(equalTo: typePickerView.bottomAnchor, constant: 0).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: 10).isActive = true
        imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor, multiplier: 0.5).isActive = true
        
        photoFloatingButton.backgroundColor = UIColor(named: "RedMain")
        photoFloatingButton.layer.cornerRadius = photoFloatingButton.frame.height / 2
        
        AppDelegate.shared().property = Property()
        AppDelegate.shared().propertyPhotos.removeAll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("User On?: \(isUserLoggedIn())")
        if !isUserLoggedIn(){
            performSegue(withIdentifier: "propertyToLogin", sender: self)
        }
    }
    
    @IBAction func photoFloatingClicked(_ sender: UIButton) {
        getPhoto()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if checkFields(){
            AppDelegate.shared().property.title = titleTextField.text!
            AppDelegate.shared().property.description = descriptionTextView.text!
            AppDelegate.shared().property.price = priceTextView.text!
            AppDelegate.shared().property.type = types[typePickerView.selectedRow(inComponent: 0)]
            
            performSegue(withIdentifier: "goToAddress", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func isUserLoggedIn()->Bool{
        if Auth.auth().currentUser != nil {
            return true
        }else{
            return false
        }
    }
    
    func getPhoto() {
        let alert = UIAlertController(title: "Note", message: "Select an image", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: { alert -> Void in
            self.openImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Photo Library"), style: .default, handler: { alert -> Void in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType){
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func checkFields() -> Bool{
        if (titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Post", "Title is required", "OK")
            titleTextField.becomeFirstResponder()
            return false
        }
        
        if (descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Post", "Description is required", "OK")
            descriptionTextView.becomeFirstResponder()
            return false
        }
        
        if (priceTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Post", "Price is required", "OK")
            priceTextView.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func showMessage(_ title:String, _ message:String, _ actionMessage:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(actionMessage, comment: actionMessage), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteImage(sender: UISwipeGestureRecognizer){
        print("Delete")
        let cell = sender.view as! UICollectionViewCell
        let indexPath = imageCollectionView.indexPath(for: cell)
        let myreact = cell.frame
        
        if let indexP = indexPath{
            
            UIView.animate(withDuration: 0.8, delay:0.0, options: .curveEaseInOut, animations: {
                cell.frame = CGRect(x: myreact.origin.x, y: myreact.origin.y-100, width: myreact.size.width, height: myreact.size.height)
                cell.alpha = 0.0
            },completion: { (finished: Bool) in
                print(indexP.row)
                //Deleting image
                //self.deletedMedia.append(self.imagesData.remove(at: indexP.row).mediaId)
                AppDelegate.shared().propertyPhotos.remove(at: indexP.row)
                cell.frame = myreact
                self.imageCollectionView.reloadData()
                
            })
            
        }
    }
}


//MARK: - UITextView

extension CreatePropertyViewController: UITextViewDelegate {
    func setUpTextView(){
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        descriptionTextView.text = "Describe your property..."
        descriptionTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray.withAlphaComponent(0.6) {
            descriptionTextView.layer.borderColor = UIColor(named: "RedMain")?.withAlphaComponent(0.6).cgColor
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Describe your property..."
            descriptionTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
            descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
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

extension CreatePropertyViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let propertyPhoto = PropertyPhoto()
        propertyPhoto.id = ""
        propertyPhoto.propertyId = ""
        propertyPhoto.photo = image
        propertyPhoto.photoString = Common.convertImageToBase64(image)
        propertyPhoto.created = ""
        
        print(Common.convertImageToBase64(image))
        AppDelegate.shared().propertyPhotos.append(propertyPhoto)
        imageCollectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension CreatePropertyViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count: \(AppDelegate.shared().propertyPhotos.count)")
        return AppDelegate.shared().propertyPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! CustomCell
        
        let UpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(deleteImage(sender:)))
        UpSwipe.direction = UISwipeGestureRecognizer.Direction.up
        cell.addGestureRecognizer(UpSwipe)
        
        cell.data = AppDelegate.shared().propertyPhotos[indexPath.row]
        return cell
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        print("KLK: \(indexPath.row)")
    //
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
    //
    //        let UpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(deleteImage(sender:)))
    //        UpSwipe.direction = UISwipeGestureRecognizer.Direction.up
    //        cell.addGestureRecognizer(UpSwipe)
    //
    //        //cell.clipsToBounds = true
    //        cell.data = imagesData[indexPath.row]
    //
    //        return cell
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("collectionView.frame.width = \(collectionView.frame.width)")
        print("collectionView.frame.height = \(collectionView.frame.height)")
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height / 2)
        //return CGSize(width: 50, height: 50)
        //        return CGSize(width: view.frame.width , height: view.frame.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom))
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        print("KLK")
    //        return imagesData.count
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        indexImage = indexPath.row
    //        showImage()
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //
    //    }
}

class CustomCell: UICollectionViewCell{
    var data:PropertyPhoto?{
        didSet{
            guard let data = data else {
                return
            }
            
            imageView.image = data.photo
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "logo_transparent")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
