//
//  FirebaseTables.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/25/21.
//

import Foundation
import Firebase
import FirebaseStorage


struct FirebaseTables {
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    let keys = Keys()
    
    func addDocumentToCollectin(with collection : Collection) {
        var ref : DocumentReference = db.collection(K.Tables.Collection).document()
        let newCollection = [K.Fields.objectId : ref.documentID as Any,
                             K.Fields.userId : keys.firbaseUserId as Any,
                             K.Fields.type : collection.type as Any,
                             K.Fields.title : collection.title as Any,
                             K.Fields.image : collection.image as Any] as [String : Any]
        
        ref = db.collection(K.Tables.Collection).addDocument(data: newCollection){
            err in
            if let err = err{
                print("Error adding document  : \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
            }
        }
        
    }
    
    func addUpdateItem(with item : Item) {
      // print("itemTO Update \(item)")
        if item.objectID != "0" {
            let newItem = [K.Fields.objectId : item.objectID,
                           K.Fields.collectionId : item.collectionId as Any,
                           K.Fields.title : item.title as Any,
                           K.Fields.notes : item.notes as Any,
                           K.Fields.genre : item.genre as Any,
                           K.Fields.author : item.author as Any,
                           K.Fields.type : item.type as Any,
                           K.Fields.image : item.image as Any,
                           K.Fields.series : item.series as Any,
                           K.Fields.own : item.own as Any,
                           K.Fields.listenedToWatchedRead : item.listenedToWatchedRead as Any,
                           K.Fields.volume : item.volume as Any,
                           K.Fields.format : item.format as Any,
                           K.Fields.userId : item.userId as Any,
                           K.Fields.website : item.website as Any] as [String : Any]
            db.collection(K.Tables.Item).document(item.objectID).updateData(newItem) {
                err in
                if let err = err {
                    print("There was an error updating the document \(err)")
                } else {
                    print("Document was updated")
                }
            }
        }else{
            var ref : DocumentReference = db.collection(K.Tables.Item).document()
            
            let newItem = [K.Fields.objectId : ref.documentID as Any,
                           K.Fields.collectionId : item.collectionId as Any,
                           K.Fields.title : item.title as Any,
                           K.Fields.notes : item.notes as Any,
                           K.Fields.genre : item.genre as Any,
                           K.Fields.author : item.author as Any,
                           K.Fields.type : item.type as Any,
                           K.Fields.image : item.image as Any,
                           K.Fields.series : item.series as Any,
                           K.Fields.own : item.own as Any,
                           K.Fields.listenedToWatchedRead: item.listenedToWatchedRead as Any,
                           K.Fields.volume : item.volume as Any,
                           K.Fields.format : item.format as Any,
                           K.Fields.userId : item.userId as Any,
                           K.Fields.website : item.website as Any] as [String : Any]
            ref = db.collection(K.Tables.Item).addDocument(data: newItem) {
                err in
                if let err = err{
                    print("Error adding document : \(err)")
                } else {
                    print("Document added with ID: \(ref.documentID)")
                }
            }
            
        }
        
    }
    
    

}
