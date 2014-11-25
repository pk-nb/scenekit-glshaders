//
//  ShaderData.swift
//  CustomShaders
//
//  Created by Nathanael Beisiegel on 11/23/14.
//  Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import UIKit
import SceneKit

class ShaderData: NSObject {
  var filename: String
  var shaderProgram: String // Read only
  
  init(filename: String) {
    self.filename = filename
    let path = NSBundle.mainBundle().pathForResource(self.filename, ofType: "shader")
    shaderProgram = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
  }
}

//class ModelData: NSObject {
//  var filename: String
//  var geometry: SCNGeometry
//  
//  init(filename: String) {
//    self.filename = filename
//    
//  }
//}

protocol SettingItem {
  var title: String {get}
  var selected: Bool {get set}
}

// Default -- None to be selected
class NoneSettingItem: SettingItem {
  var title: String = "None"
  var selected: Bool = true
}

//class ModelSettingItem: SettingItem {
//  
//}

class ShaderSettingItem: SettingItem {
  var shaderData: ShaderData
  var selected: Bool = false
  var title: String {
    get {
      return shaderData.filename
    }
  }
  var shaderProgram: String {
    get {
      return shaderData.shaderProgram
    }
  }
  
  init(shaderData: ShaderData) {
    self.shaderData = shaderData
  }
}

class Settings: NSObject {
  var items: [SettingItem]
  
  init(items: [SettingItem]) {
    self.items = items
  }
  
  func selected() -> SettingItem? {
    for item in items {
      if item.selected {
        return item
      }
    }
    return nil
  }
}




