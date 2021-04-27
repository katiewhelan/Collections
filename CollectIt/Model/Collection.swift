//
//  Collection.swift
//  CollectIt
//
//  Created by Kathryn Whelan on 2/23/21.
//

import Foundation

struct Collection: Codable {
  let objectID : String
  let title: String?
  let type: String?
  let image: String?
  let userId: String
}
