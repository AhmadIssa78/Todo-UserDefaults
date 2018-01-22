//
//  DataModel.swift
//  Todo-UserDefaults
//
//  Created by Ahmad Issa on 1/18/18.
//  Copyright © 2018 Ahmad Issa. All rights reserved.
//

import Foundation

//To refelect attribute and data on cell we need to deal with both as data so we create DataModel for that to make all data grouped in on Model.
class Item: Codable{ // this to make this call follow the Encode and Decode Protocal allways the Codable is for Standard Data Type Only.
    var titleItem : String = ""
    var done : Bool = false
}
