//
//  AlertViewController.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 3/2/21.
//

import UIKit

class AlertViewController: UIViewController {
    
    let firebase = FirebaseTables()
    let keys = Keys()

    @IBOutlet weak var imageUrlTextfield: UITextField!
    @IBOutlet weak var cancleButotn: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBar: UIView!
    @IBOutlet weak var collectionNameTextfield: UITextField!
    @IBOutlet weak var collectionTypeTextfield: UITextField!
    
    @IBAction func addNewCollectionPressed(_ sender: UIButton) {
        if collectionNameTextfield.text?.isEmpty == true
            || collectionTypeTextfield.text?.isEmpty == true ||
            imageUrlTextfield.text?.isEmpty == true {
           
            print("Do not have needed data")
        } else {
            let collection = Collection(objectID: "0",
                title: collectionNameTextfield.text!,
                type: collectionTypeTextfield.text!,
                image: imageUrlTextfield.text!,
                userId: keys.firbaseUserId)
            firebase.addDocumentToCollectin(with : collection)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelNewCollectionPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlertTextfields()
    }
    
    private func setAlertTextfields() {
        let placeHolderColor = UIColor.lightGray
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : placeHolderColor];
        let collectionNameAttributedString = NSAttributedString(string: "Collection Name", attributes: attributedStringColor)
        let collectionTypeAttributedString = NSAttributedString(string: "Collection Type", attributes: attributedStringColor)
        let imageTypeAttributedString = NSAttributedString(string: "Image Url", attributes: attributedStringColor)
   
        collectionNameTextfield.attributedPlaceholder = collectionNameAttributedString
        collectionNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        collectionNameTextfield.borderStyle = .roundedRect
        collectionNameTextfield.layer.borderWidth = 0.5
        
        collectionTypeTextfield.attributedPlaceholder = collectionTypeAttributedString
        collectionTypeTextfield.layer.borderColor = UIColor.lightGray.cgColor
        collectionTypeTextfield.borderStyle = .roundedRect
        collectionTypeTextfield.layer.borderWidth = 0.5
        
        imageUrlTextfield.attributedPlaceholder = imageTypeAttributedString
        imageUrlTextfield.layer.borderColor = UIColor.lightGray.cgColor
        imageUrlTextfield.borderStyle = .roundedRect
        imageUrlTextfield.layer.borderWidth = 0.5
        
        if traitCollection.userInterfaceStyle == .light {
            titleBar.backgroundColor = .darkGray
            addButton.backgroundColor = .darkGray
            cancleButotn.backgroundColor = .darkGray
            titleLabel.backgroundColor = .darkGray
           }
        }
}


