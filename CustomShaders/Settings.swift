//
//  Settings.swift
//  CustomShaders
//
//  Created by Nathanael Beisiegel on 11/24/14.
//  Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import Foundation
import SceneKit

class AllSettings: NSObject {
  
  var modelSettings = Settings(items: [
    ModelSettingItem(modelData: ModelData(name: "Sphere", node: AllSettings.sphereNode(), nodeSetup: nil),
                     selected:  true),
    ModelSettingItem(modelData: ModelData(filename: "ship", nodeName: "shipMesh", nodeSetup: nil)),
    ModelSettingItem(modelData: ModelData(filename: "suzanne_materials", nodeName: "Suzanne", nodeSetup: nil)),
    ModelSettingItem(modelData: ModelData(filename: "suzanne_painted", nodeName: "Suzanne", nodeSetup: nil))
    ])
  
  var geometrySettings = Settings(items: [
    NoneSettingItem(),
    ShaderSettingItem(shaderData: ShaderData(filename: "geometry_ripple")),
    ShaderSettingItem(shaderData: ShaderData(filename: "sm_geom"))
  ])

  var surfaceSettings = Settings(items: [
    NoneSettingItem(),
    ShaderSettingItem(shaderData: ShaderData(filename: "sm_surf"))
  ])

  var lightingSettings = Settings(items: [
    NoneSettingItem(),
    ShaderSettingItem(shaderData: ShaderData(filename: "toon")),
    ShaderSettingItem(shaderData: ShaderData(filename: "sm_light"))
  ])
  
  var fragmentSettings = Settings(items: [
    NoneSettingItem(),
    ShaderSettingItem(shaderData: ShaderData(filename: "sm_frag"))
  ])
  
  private class func sphereNode() -> SCNNode {
    let sphere = SCNSphere(radius: 3.0)
    sphere.firstMaterial!.diffuse.contents = UIColor.cyanColor()
    sphere.firstMaterial!.ambient.contents = UIColor.whiteColor()
    return SCNNode(geometry: sphere)
  }
  
}
