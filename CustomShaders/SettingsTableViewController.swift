//
//  SettingsTableViewController.swift
//  CustomShaders
//
//  Created by Nathanael Beisiegel on 11/24/14.
//  Copyright (c) 2014 Nathanael Beisiegel. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  var settingData: [SettingItem] = []
  var gameUpdater: (() -> ())? // Optional lambda to update, called on row selection
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ShaderSettingCell", forIndexPath: indexPath)
    
    cell.textLabel!.text = settingData[indexPath.row].title
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
    
    // Set settings to true, then trigger reload to parent
    for i in 0..<settingData.count {
      settingData[i].selected = (i == indexPath.row)
    }
    
    // Animate down, updating view after settings popover closes
    self.dismissViewControllerAnimated(true, completion: {
      // Update Game
      
      self.gameUpdater?()
      return
    })
  }

  // MARK: - Status Bar
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
