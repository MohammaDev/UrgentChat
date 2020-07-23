//
//  TableViewController.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 09/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func didUpdateTheme(_ SettingsViewController : UITableViewController, _ selectedTheme : String)
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var systemModeSwitch: UISwitch!
    @IBOutlet weak var lightModeSwitch: UISwitch!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    static var delegate : SettingsViewControllerDelegate?
    var selectedTheme : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedTheme != nil ? self.reloadSettings(selectedTheme!) : self.reloadSettings(K.Theme.dynamic)
    }

    @IBAction func systemModeSwitched(_ sender: UISwitch) {
        if systemModeSwitch.isOn == true {
            lightModeSwitch.setOn(false, animated: true)
            darkModeSwitch.setOn(false, animated: true)
            self.askForChangeThem(to: K.Theme.dynamic)
        }
    }
    
    @IBAction func lightModeSwitched(_ sender: UISwitch) {
        if lightModeSwitch.isOn == true {
            systemModeSwitch.setOn(false, animated: true)
            darkModeSwitch.setOn(false, animated: true)
            self.askForChangeThem(to: K.Theme.light)
        }
    }
    
    @IBAction func darkModeSwitched(_ sender: UISwitch) {
        if darkModeSwitch.isOn == true {
            systemModeSwitch.setOn(false, animated: true)
            lightModeSwitch.setOn(false, animated: true)
            self.askForChangeThem(to: K.Theme.dark)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! WebViewController
        webVC.link = self.getURL(segue.identifier!)
    }

    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        let footer: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        let nsObject: AnyObject? = Bundle.main.infoDictionary?[K.dictionaryIdentifier] as AnyObject?
        let versionNumber = nsObject as? String
        
        if versionNumber != nil {
            footer.textLabel?.text = "\(footer.textLabel?.text ?? K.empty) \(versionNumber!)"
            footer.textLabel?.textAlignment = .center
        }
        else {
            footer.textLabel?.text = K.empty
        }
        
    }
}
