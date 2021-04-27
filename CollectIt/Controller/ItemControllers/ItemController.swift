//
//  ViewController.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 3/17/21.
//

import UIKit
import Firebase
import FirebaseStorage

class ItemController: UIViewController , UITextFieldDelegate, UITextViewDelegate{
    var originalItem : Item?
    var selectedCollectionId : String?
    var isEditMode : Bool = false
    let firebase = FirebaseTables()
    let keys = Keys()
   
    private let storage = Storage.storage().reference()

    @IBOutlet weak var titleStack: UIStackView!
    @IBOutlet weak var authorStack: UIStackView!
    @IBOutlet weak var formatStack: UIStackView!
    @IBOutlet weak var notesStack: UIStackView!
    @IBOutlet weak var seriesStack: UIStackView!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var genreStack: UIStackView!
    @IBOutlet weak var volumeStack: UIStackView!
    @IBOutlet weak var watchedStack: UIStackView!
    @IBOutlet weak var ownStack: UIStackView!
    @IBOutlet weak var deleteStack: UIStackView!
    @IBOutlet weak var websiteStack: UIStackView!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var formatTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var seriesTextField: UITextField!
    @IBOutlet weak var listenedToWatchedReadSwitch: UISwitch!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
  
    @IBOutlet weak var ownSwitch: UISwitch!
    @IBOutlet weak var websiteTextField: UITextView!
    
    @IBAction func CameraButtonPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: false)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cameraButton.tintColor = .white
        scrollView.isUserInteractionEnabled = true
        setFields()
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        if isEditMode {
            editMode()
        } else {
            viewMode()
        }
    }
    
    func addTextViewLink(){
            let websitePath = websiteTextField.text ?? "www.google.com"
            let websiteText = titleTextField.text ?? "Website"
            let websiteLink = NSAttributedString.addHyperlink(for : websitePath, in: websiteText, as: websiteText)
            self.websiteTextField.attributedText = websiteLink
    }
    
    func removeTextViewLink(){
            let websiteText = titleTextField.text ?? "Website"
            let unLinkWebsite = NSAttributedString.removeHyperlink(in: websiteText, as: websiteText)
            self.websiteTextField.attributedText = unLinkWebsite
    }
    
    @objc func editTapped() {
        let newItem =
            Item(objectID: originalItem?.objectID ?? "0",
                 collectionId: selectedCollectionId!,
                 userId : keys.firbaseUserId,
                 title: titleTextField.text,
                 notes: notesTextField.text,
                 genre: genreTextField.text,
                 author: authorTextField.text,
                 type: originalItem?.type ?? "",
                 image: imageTextField.text,
                 series: seriesTextField.text,
                 own: ownSwitch.isOn,
                 listenedToWatchedRead: listenedToWatchedReadSwitch.isOn,
                 volume: volumeTextField.text,
                 format: formatTextField.text,
                 website : websiteTextField.text)
        
        if isEditMode {
            firebase.addUpdateItem(with: newItem)
            viewMode()
        }else{
            editMode()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func hideKeyboard(){
        imageTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification : Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
       
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            //view.frame.origin.y = keyboardRect.height
            view.frame.origin.y = -250
        }else{
            view.frame.origin.y = 0
        }
    }
    
    private func viewMode(){
        isEditMode = false
        deleteStack.isHidden = true
        scrollView.isUserInteractionEnabled = true
        cameraButton.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        setViewableFields()
        titleTextField.isUserInteractionEnabled = false
        titleTextField.borderStyle = .none
        authorTextField.isUserInteractionEnabled = false
        authorTextField.borderStyle = .none
        formatTextField.isUserInteractionEnabled = false
        formatTextField.borderStyle = .none
        seriesTextField.isUserInteractionEnabled = false
        seriesTextField.borderStyle = .none
        notesTextField.isUserInteractionEnabled = false
        notesTextField.layer.borderWidth = 0
        notesTextField.layer.borderColor = UIColor.clear.cgColor
        imageTextField.isUserInteractionEnabled = false
        imageTextField.borderStyle = .none
        websiteTextField.layer.borderWidth = 0
        websiteTextField.layer.borderColor = UIColor.clear.cgColor
        genreTextField.isUserInteractionEnabled = false
        genreTextField.borderStyle = .none
        volumeTextField.isUserInteractionEnabled = false
        volumeTextField.borderStyle = .none
        ownSwitch.isUserInteractionEnabled = false
        listenedToWatchedReadSwitch.isUserInteractionEnabled = false
    }
    
    private func setViewableFields(){
        if volumeTextField.text?.isEmpty == true{
            volumeStack.isHidden = true
        }
        if authorTextField.text?.isEmpty == true{
            authorStack.isHidden = true
        }
        if titleTextField.text?.isEmpty == true{
            titleStack.isHidden = true
        }
        if genreTextField.text?.isEmpty == true{
            genreStack.isHidden = true
        }
        if notesTextField.text?.isEmpty == true{
            notesStack.isHidden = true
        }
        if seriesTextField.text?.isEmpty == true{
            seriesStack.isHidden = true
        }
        if imageTextField.text?.isEmpty == true{
            imageStack.isHidden = true
        }
        if originalItem?.own == nil{
            ownStack.isHidden = true
        }
        if originalItem?.listenedToWatchedRead == nil{
            watchedStack.isHidden = true
        }
        if formatTextField.text?.isEmpty == true {
            formatStack.isHidden = true
        }
        if websiteTextField.text?.isEmpty == true {
            websiteStack.isHidden = true
        } else {
            addTextViewLink()
        }
        
        if let url = URL(string : imageTextField.text ?? "") {
                let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                    guard let data = data , error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.mainImage.image = image
                    }
                })
            task.resume()
        }
    }

    private func editMode(){
        websiteTextField.text = originalItem?.website
        isEditMode = true
        deleteStack.isHidden = false
        scrollView.isUserInteractionEnabled = true
        cameraButton.isHidden = false
        if traitCollection.userInterfaceStyle == .light {
            cameraButton.tintColor = .black
        }
        titleTextField.isUserInteractionEnabled = true
        titleTextField.borderStyle = .roundedRect
        authorTextField.isUserInteractionEnabled = true
        authorTextField.borderStyle = .roundedRect
        formatTextField.isUserInteractionEnabled = true
        formatTextField.borderStyle = .roundedRect
        seriesTextField.isUserInteractionEnabled = true
        seriesTextField.borderStyle = .roundedRect
        notesTextField.isUserInteractionEnabled = true
        notesTextField.layer.borderWidth = 1
        notesTextField.layer.borderColor = UIColor.lightGray.cgColor
        imageTextField.isUserInteractionEnabled = true
        imageTextField.borderStyle = .roundedRect
        websiteTextField.isUserInteractionEnabled = true
        removeTextViewLink()
        websiteTextField.text = originalItem?.website
        websiteTextField.isEditable = true
        websiteTextField.layer.borderWidth = 1
        websiteTextField.layer.borderColor = UIColor.lightGray.cgColor
        genreTextField.isUserInteractionEnabled = true
        genreTextField.borderStyle = .roundedRect
        volumeTextField.isUserInteractionEnabled = true
        volumeTextField.borderStyle = .roundedRect
        listenedToWatchedReadSwitch.isUserInteractionEnabled = true
        ownSwitch.isUserInteractionEnabled = true
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editTapped))

        titleStack.isHidden = false
        authorStack.isHidden = false
        formatStack.isHidden = false
        notesStack.isHidden = false
        seriesStack.isHidden = false
        imageStack.isHidden = false
        genreStack.isHidden = false
        volumeStack.isHidden = false
        watchedStack.isHidden = false
        ownStack.isHidden = false
        websiteStack.isHidden = false
    }
    
    func setFields(){
        if let url = URL(string : originalItem?.image ?? "") { //set up a default image in storage with a path to fill in
                let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                    guard let data = data , error == nil else {
                        return
                    }
                
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.mainImage.image = image
                    }
                })
            task.resume()
        }

        if let item = originalItem {
            titleTextField.text = item.title
            authorTextField.text = item.author
            formatTextField.text = item.format
            seriesTextField.text = item.series
            imageTextField.text = item.image
            notesTextField.text = item.notes
            genreTextField.text = item.genre
            volumeTextField.text = item.volume
            websiteTextField.text = item.website
            ownSwitch.setOn(item.own ?? false, animated: false)
            listenedToWatchedReadSwitch.setOn(item.listenedToWatchedRead ?? false, animated: false)
        }
    }
    
  
    
}
extension ItemController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)
        guard let image =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        if let itemIdUnwrapped = originalItem?.objectID {

        guard let imageData = image.pngData() else{return}
        
        storage.child("images/Item/Item_\(itemIdUnwrapped).png").putData(imageData, metadata: nil, completion: {_,error in
            guard error == nil else {
                print("Failed to Upload")
                return
            }
            self.storage.child("images/Item/Item_\(itemIdUnwrapped).png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                DispatchQueue.main.async {
                    self.imageTextField.text = urlString
                    self.mainImage.image = image
                }
            })
        })
        }
    }
}
