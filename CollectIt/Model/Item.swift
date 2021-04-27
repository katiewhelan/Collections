//
//  ItemModel.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/23/21.
//

import Foundation

struct Item : Codable {
    let objectID : String
    let collectionId : String
    let userId : String
    let title : String?
    let notes : String?
    let genre : String?
    let author : String?
    let type : String?
    let image : String?
    let series : String?
    let own : Bool?
    let listenedToWatchedRead : Bool?
    let volume : String?
    let format : String?
    let website : String?
}




