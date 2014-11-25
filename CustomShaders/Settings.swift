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
    ModelSettingItem(modelData: ModelData(name: "Sphere", node: AllSettings.sphereNode()),
                     selected:  true),
    ModelSettingItem(modelData: ModelData(name: "Cube", node: AllSettings.cubeNode())),
    ModelSettingItem(modelData: ModelData(name: "Torus", node: AllSettings.torusNode())),
    ModelSettingItem(modelData: ModelData(name: "Text", node: AllSettings.textNode("Graphics\nHearts\nYou"))),
    ModelSettingItem(modelData: ModelData(name: "Planets", node: AllSettings.planets())),
    ModelSettingItem(modelData: ModelData(filename: "ship", nodeName: "shipMesh")),
    ModelSettingItem(modelData: ModelData(filename: "suzanne_materials", nodeName: "Suzanne")),
    ModelSettingItem(modelData: ModelData(filename: "suzanne_painted", nodeName: "Suzanne"))
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
  
  // MARK: - Class methods to build sample nodes
  
  // Simple, cyan sphere
  private class func sphereNode() -> SCNNode {
    let sphere = SCNSphere(radius: 3.0)
    sphere.firstMaterial!.diffuse.contents = UIColor.cyanColor()
    sphere.firstMaterial!.ambient.contents = UIColor.whiteColor()
    return SCNNode(geometry: sphere)
  }
  
  // Green, rounded cube
  private class func cubeNode() -> SCNNode {
    let cube = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 1.5)
    cube.firstMaterial!.diffuse.contents = UIColor.greenColor()
    cube.firstMaterial!.ambient.contents = UIColor.whiteColor()
    return SCNNode(geometry: cube)
  }
  
  // Text!
  private class func textNode(text: String) -> SCNNode {
    
    let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
    textGeometry.font = UIFont(name: "Avenir", size: 2.0)
    textGeometry.containerFrame = CGRect(origin: CGPoint(x: -5.0, y: -15.0), size: CGSize(width: 10.0, height: 20.0))
//    textGeometry.flatness = 0.2 // Smooth it more
//    textGeometry.chamferRadius = 0.25
    textGeometry.firstMaterial!.diffuse.contents = UIColor(hue: 0.9, saturation: 0.8, brightness: 1.0, alpha: 1.0)
    textGeometry.firstMaterial!.ambient.contents = UIColor.whiteColor()
    return SCNNode(geometry: textGeometry)
  }
  
  // Torus
  private class func torusNode() -> SCNNode {
    let torus = SCNTorus(ringRadius: 4.0, pipeRadius: 1.5)
    torus.firstMaterial!.diffuse.contents = UIColor(hue: 0.4, saturation: 0.8, brightness: 1.0, alpha: 1.0)
    torus.firstMaterial!.ambient.contents = UIColor.whiteColor()
    return SCNNode(geometry: torus)
  }
  
  // Planets
  private class func planets() -> SCNNode {
    let sun = SCNSphere(radius: 2.0)
    sun.firstMaterial!.diffuse.contents = UIColor(hue: 0.7, saturation: 0.8, brightness: 1.0, alpha: 1.0)
    sun.firstMaterial!.ambient.contents = UIColor.whiteColor()
    
    let moon = SCNSphere(radius: 1.0)
    moon.firstMaterial!.diffuse.contents = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.9, alpha: 1.0)
    moon.firstMaterial!.ambient.contents = UIColor.whiteColor()
    
    let miniMoon = SCNSphere(radius: 0.5)
    moon.firstMaterial!.diffuse.contents = UIColor(hue: 0.3, saturation: 0.5, brightness: 0.9, alpha: 1.0)
    moon.firstMaterial!.ambient.contents = UIColor.whiteColor()
    
    
    let sunNode = SCNNode(geometry: sun)
    let dummySunNode = SCNNode() // used for different rotation speed
    
    let moonNode = SCNNode(geometry: moon)
    let moonNode2 = SCNNode(geometry: moon)
    
    let miniMoonNode = SCNNode(geometry: miniMoon)
    let miniMoonNode2 = SCNNode(geometry: miniMoon)
    let miniMoonNode3 = SCNNode(geometry: miniMoon)
    
    moonNode.position = SCNVector3Make(6, 0, -3)
    moonNode2.position = SCNVector3Make(-7, 0, 7)
    
    miniMoonNode.position = SCNVector3Make(2, 0, 0)
    miniMoonNode2.position = SCNVector3Make(-3, 0, 1)
    miniMoonNode3.position = SCNVector3Make(1, 0, -2)
    
    moonNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 4, z: 0, duration: 1)))
    moonNode2.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 1, z: 0, duration: 1)))
    
    miniMoonNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 3, z: 0, duration: 1)))
    miniMoonNode2.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
    miniMoonNode3.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 1, z: 0, duration: 1)))
    
    sunNode.addChildNode(moonNode)
    dummySunNode.addChildNode(moonNode2)
    moonNode.addChildNode(miniMoonNode)
    moonNode2.addChildNode(miniMoonNode2)
    moonNode2.addChildNode(miniMoonNode3)
    
    sunNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
    dummySunNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 3, z: 0, duration: 1)))
    
    let rootNode = SCNNode()
    rootNode.addChildNode(sunNode)
    rootNode.addChildNode(dummySunNode)
    return rootNode
  }
}
