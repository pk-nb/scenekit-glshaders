//
//  Settings.swift
//  CustomShaders
//
//  Created by Nathanael Beisiegel on 11/24/14.
//  Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import Foundation

class AllSettings: NSObject {
  
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
  
}
