//
//  Keys.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/23/21.
//


import Foundation
import FirebaseAuth
import InstantSearch
import Firebase

struct Keys {
    let client = SearchClient(appID: "", apiKey: "")
    let firbaseUserId = Auth.auth().currentUser?.uid ?? ""
}
