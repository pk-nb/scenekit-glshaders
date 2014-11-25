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

class GameViewController: UIViewController, GameUpdateDelagate {
  
  @IBOutlet weak var scnView: SCNView!
  private var currentSettingsPopover: UIPopoverController? = nil
  var settings: AllSettings = AllSettings()
  private var currentNode: SCNNode = SCNNode()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // create a new scene
    let scene = SCNScene()

    initLightsAndCamera(scene)
    
    // Default Model
    let sphere = SCNSphere(radius: 3.0)
    sphere.firstMaterial!.diffuse.contents = UIColor.cyanColor()
    sphere.firstMaterial!.ambient.contents = UIColor.whiteColor()
    let sphereNode = SCNNode(geometry: sphere)
    
    let suzanne = SCNScene(named: "art.scnassets/suzanne_painted.dae")?.rootNode.childNodeWithName("Suzanne", recursively: true)
    suzanne!.geometry?.firstMaterial!.diffuse.contents = UIColor.cyanColor()
    suzanne!.geometry?.firstMaterial!.ambient.contents = UIColor.whiteColor()
    
    let ship = SCNScene(named: "art.scnassets/ship.dae")?.rootNode.childNodeWithName("shipMesh", recursively: true)
    
//    let path = NSBundle.mainBundle().pathForResource("geometry_ripple", ofType: "shader")
//    let shaderProgram = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
//    
//    let smSurfPath = NSBundle.mainBundle().pathForResource("sm_surf", ofType: "shader")
//    let smSurfShaderProgram = String(contentsOfFile: smSurfPath!, encoding: NSUTF8StringEncoding, error: nil)
//    
//    let toonPath = NSBundle.mainBundle().pathForResource("toon", ofType: "shader")
//    let toonShaderProgram = String(contentsOfFile: toonPath!, encoding: NSUTF8StringEncoding, error: nil)
//    
//    let fragPath = NSBundle.mainBundle().pathForResource("sm_frag", ofType: "shader")
//    let fragShaderProgram = String(contentsOfFile: fragPath!, encoding: NSUTF8StringEncoding, error: nil)
    
    
//    sphereNode.geometry!.shaderModifiers = [SCNShaderModifierEntryPointSurface : smSurfShaderProgram!, SCNShaderModifierEntryPointGeometry: shaderProgram!, SCNShaderModifierEntryPointFragment: fragShaderProgram!]
    
    
//    sphereNode.geometry!.shaderModifiers = [SCNShaderModifierEntryPointGeometry : shaderProgram!]
//    sphereNode.geometry!.shaderModifiers = [SCNShaderModifierEntryPointLightingModel: toonShaderProgram!]
//    sphereNode.geometry!.shaderModifiers = [SCNShaderModifierEntryPointFragment: fragShaderProgram!]
    
    scene.rootNode.addChildNode(suzanne!)
    currentNode = suzanne!
    
    // set the scene to the view
    scnView.scene = scene
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor.blackColor()
    
    // add a tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
    let gestureRecognizers = NSMutableArray()
    gestureRecognizers.addObject(tapGesture)
    if let existingGestureRecognizers = scnView.gestureRecognizers {
      gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
    }
    scnView.gestureRecognizers = gestureRecognizers
    
    // Keep Shaders animating
    scnView.playing = true
    scnView.loops = true
  }
  
  
  func updateNode() {
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
    
//      newShaderModifiers[SCNShaderModifierEntryPointGeometry] = settings.geometrySettings.selected()!.shaderProgram
//      SCNShaderModifierEntryPointSurface : settings.surfaceSettings.selected()!.shaderProgram,
//      SCNShaderModifierEntryPointLightingModel : settings.lightingSettings.selected()!.shaderProgram,
//      SCNShaderModifierEntryPointFragment : settings.lightingSettings.selected()!.shaderProgram
//    ]
//    
    
    currentNode.geometry!.shaderModifiers = newShaderModifiers
  }
  
  func updateGame() {
    updateNode()
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
  
//  override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Release any cached data, images, etc that aren't in use.
//  }
  
  
  @IBAction func settingsButtonClicked(sender: UIBarButtonItem) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//    if currentSettingsPopover != nil {
//      currentSettingsPopover?.dismissPopoverAnimated(true)
//    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if let popoverSegue = segue as? UIStoryboardPopoverSegue {
//      currentSettingsPopover = popoverSegue.popoverController
//    }
    
    switch segue.identifier!  {
    case "geometrySettings":
      let settingsTableView = segue.destinationViewController as SettingsTableViewController
      settingsTableView.settingData = settings.geometrySettings.items
      settingsTableView.gameUpdater = self
    case "surfaceSettings":
      let settingsTableView = segue.destinationViewController as SettingsTableViewController
      settingsTableView.settingData = settings.surfaceSettings.items
      settingsTableView.gameUpdater = self
    case "lightSettings":
      let settingsTableView = segue.destinationViewController as SettingsTableViewController
      settingsTableView.settingData = settings.lightingSettings.items
      settingsTableView.gameUpdater = self
    case "fragmentSettings":
      let settingsTableView = segue.destinationViewController as SettingsTableViewController
      settingsTableView.settingData = settings.fragmentSettings.items
      settingsTableView.gameUpdater = self
    default:
      break
    }
    
  }
}

