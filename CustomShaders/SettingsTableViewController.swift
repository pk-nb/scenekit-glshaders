//
//  SettingsTableViewController.swift
//  CustomShaders
//
//  Created by Nathanael Beisiegel on 11/24/14.
//  Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import UIKit

protocol GameUpdateDelagate {
  func updateGame()
}

class SettingsTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate {
  
  var settingData: [SettingItem] = []
  var gameUpdater: GameUpdateDelagate? = nil
  
  func setSettingData(settingData: [SettingItem]) {
    self.settingData = settingData
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ShaderSettingCell", forIndexPath: indexPath) as UITableViewCell
    
    cell.textLabel.text = settingData[indexPath.row].title
    if settingData[indexPath.row].selected {
      cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    else {
      cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    return cell
  }
  
  // MARK: - Table View Delagate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Set settings to true, then trigger reload to parent (through delegation?)
    for i in 0..<settingData.count {
      settingData[i].selected = i == indexPath.row
    }
    
    self.dismissViewControllerAnimated(true, completion: {
      // Update Game
      self.gameUpdater?.updateGame()
      return
    })
  }

  // MARK: - Status Bar
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  //  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
  //    return UIBarPosition.TopAttached
  //  }
}
