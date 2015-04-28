//
//  GameViewController.swift
//  CustomShaders
//
//  Created by Nathanael Beisiegel on 11/18/14.
//  Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
  
  @IBOutlet weak var scnView: SCNView!
  private var settings: AllSettings = AllSettings() // Modal object that holds settings with models, shaders, etc
  private var currentNode: SCNNode?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // create a new scene
    let scene = SCNScene()

    // Configure lighting / camera nodes
    initLightsAndCamera(scene)
    
    // set the scene to the view
    scnView.scene = scene
    
    // Load Model into scene
    updateModel()
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor(hue: 0.8, saturation: 0.1, brightness: 0.2, alpha: 1.0)
    
    // add a tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
    let gestureRecognizers = NSMutableArray()
    gestureRecognizers.addObject(tapGesture)
    if let existingGestureRecognizers = scnView.gestureRecognizers {
      gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
    }
    scnView.gestureRecognizers = gestureRecognizers as [AnyObject]
    
    // Keep Shaders animating
    scnView.playing = true
    scnView.loops = true
  }
  
  
  func initLightsAndCamera(scene: SCNScene) {
    // create and add a camera to the scene
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    scene.rootNode.addChildNode(cameraNode)
    
    // place the camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
    
    // create and add a light to the scene
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light!.type = SCNLightTypeOmni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
    scene.rootNode.addChildNode(lightNode)
    
    // create and add an ambient light to the scene
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLightTypeAmbient
    ambientLightNode.light!.color = UIColor.darkGrayColor()
    scene.rootNode.addChildNode(ambientLightNode)
  }
  
  
  func handleTap(gestureRecognize: UIGestureRecognizer) {
    // check what nodes are tapped
    let p = gestureRecognize.locationInView(scnView)
    if let hitResults = scnView.hitTest(p, options: nil) {
      // check that we clicked on at least one object
      if hitResults.count > 0 {
        // retrieved the first clicked object
        let result: AnyObject! = hitResults[0]
        
        // get its material
        let material = result.node!.geometry!.firstMaterial!
        
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        
        // on completion - unhighlight
        SCNTransaction.setCompletionBlock {
          SCNTransaction.begin()
          SCNTransaction.setAnimationDuration(0.5)
          
          material.emission.contents = UIColor.blackColor()
          
          SCNTransaction.commit()
        }
        
        material.emission.contents = UIColor.redColor()
        
        SCNTransaction.commit()
      }
    }
  }
  
  
  // MARK: - Updating Lambdas
  
  func updateShaders() {
    // Recreate shader modifiers
    var newShaderModifiers: [String: String] = [:]
    if let settingItem = settings.geometrySettings.selected() as? ShaderSettingItem {
      newShaderModifiers[SCNShaderModifierEntryPointGeometry] = settingItem.shaderProgram
    }
    
    if let settingItem = settings.surfaceSettings.selected() as? ShaderSettingItem {
      newShaderModifiers[SCNShaderModifierEntryPointSurface] = settingItem.shaderProgram
    }
    
    if let settingItem = settings.lightingSettings.selected() as? ShaderSettingItem {
      newShaderModifiers[SCNShaderModifierEntryPointLightingModel] = settingItem.shaderProgram
    }
    
    if let settingItem = settings.fragmentSettings.selected() as? ShaderSettingItem {
      newShaderModifiers[SCNShaderModifierEntryPointFragment] = settingItem.shaderProgram
    }

    currentNode!.geometry?.shaderModifiers = newShaderModifiers
    currentNode!.enumerateChildNodesUsingBlock( { (node: SCNNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
      node.geometry?.shaderModifiers = newShaderModifiers
      return
    })
  }
  
  
  func updateModel() {
    if let modelItem = settings.modelSettings.selected() as? ModelSettingItem {
      if currentNode == nil {
        currentNode = modelItem.modelData.node
        scnView.scene?.rootNode.addChildNode(currentNode!)
      }
      else if currentNode! != modelItem.modelData.node {
        scnView.scene?.rootNode.replaceChildNode(currentNode!, with: modelItem.modelData.node)
        currentNode = modelItem.modelData.node
      }
    }
    
    updateShaders()
  }
  
  // MARK: - Lifecycle / Storyboard
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  // TODO modify this for the table view?
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> Int {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    } else {
      return Int(UIInterfaceOrientationMask.All.rawValue)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // For the different settings popovers, set the items for that button 
    // and callback lambda for update
    switch segue.identifier!  {
    case "modelSettings":
      let settingsTableView = segue.destinationViewController as! SettingsTableViewController
      settingsTableView.settingData = settings.modelSettings.items
      settingsTableView.gameUpdater = updateModel
    case "geometrySettings":
      let settingsTableView = segue.destinationViewController as! SettingsTableViewController
      settingsTableView.settingData = settings.geometrySettings.items
      settingsTableView.gameUpdater = updateShaders
    case "surfaceSettings":
      let settingsTableView = segue.destinationViewController as! SettingsTableViewController
      settingsTableView.settingData = settings.surfaceSettings.items
      settingsTableView.gameUpdater = updateShaders
    case "lightSettings":
      let settingsTableView = segue.destinationViewController as! SettingsTableViewController
      settingsTableView.settingData = settings.lightingSettings.items
      settingsTableView.gameUpdater = updateShaders
    case "fragmentSettings":
      let settingsTableView = segue.destinationViewController as! SettingsTableViewController
      settingsTableView.settingData = settings.fragmentSettings.items
      settingsTableView.gameUpdater = updateShaders
    default:
      break
    }
  }
}

