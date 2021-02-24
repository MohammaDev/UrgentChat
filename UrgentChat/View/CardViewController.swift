//
//  ViewController.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 16/02/2021.
//  Copyright © 2021 Mohammad Alotaibi. All rights reserved.
//

import UIKit

protocol CardViewControllerDelegate {
    func didSelectRecord(phoneNumber: String)
    func didSelectTemplate()
    func didSelectButton()
}

class CardViewController: UIViewController {

    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var historyButton: RoundedButton!
    @IBOutlet weak var templatesButton: RoundedButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    var arrayOfRecords = [HistoryRecord]()
    var arrayOfTemplates = [
        "Hello, send me your location",
        "Hi, Here is my location"
    ]
    var delegate:CardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let encodedData = userDefaults.value(forKey:"Records") as? Data {
            arrayOfRecords = try! PropertyListDecoder().decode([HistoryRecord].self, from: encodedData)
        }
        
        arrayOfTemplates = userDefaults.object(forKey: "Template") as? [String] ?? arrayOfTemplates
        
        historyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        tableView.register(UINib(nibName: "TemplateCell", bundle: nil), forCellReuseIdentifier: "TemplateCell")
    }
    
    @IBAction func historyButtonPressed(_ sender: UIButton) {
        historyButton.isPressed = true
        templatesButton.isPressed = false
        tableView.reloadData()
        delegate?.didSelectButton()
    }
    
    @IBAction func templatesButtonPressed(_ sender: UIButton) {
        historyButton.isPressed = false
        templatesButton.isPressed = true
        tableView.reloadData()
        delegate?.didSelectButton()
    }
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete All Records", message: "Are you sure that you want to move all records to the trash?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.arrayOfRecords.removeAll()
            self.userDefaults.set(try? PropertyListEncoder().encode(self.arrayOfRecords), forKey: "Records")
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyButton.isPressed{
            titleLable.text = "Chat History"
            descriptionLable.text = "Your recent operations will be shown here.\nYou can start your chat by tapping on it."
            return arrayOfRecords.count
        }
        else {
            titleLable.text = "Templates"
            descriptionLable.text = "Press on (+) button if you want to add more templates. You can edit the current templates by tapping on them."
            return arrayOfTemplates.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kind = userDefaults.object(forKey: K.Theme.currentTheme) as? String
        
        if historyButton.isPressed {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            cell.flageImage.image = arrayOfRecords[indexPath.row].recordImage.getImage()
            cell.numberLable.text = arrayOfRecords[indexPath.row].recordNumber
            cell.dateLable.text = arrayOfRecords[indexPath.row].recordDate
            cell.baseView.backgroundColor = UIColor(named: "\(kind!)\(K.Card.backgroundColor)")
            cell.numberLable.textColor = UIColor(named: "\(kind!)\(K.TextField.textColor)")
            cell.dateLable.textColor = UIColor(named: "\(kind!)\(K.TextField.textColor)")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCell", for: indexPath) as! TemplateCell
            cell.templateLable.text = arrayOfTemplates[indexPath.row]
            cell.baseView.backgroundColor = UIColor(named: "\(kind!)\(K.Card.backgroundColor)")
            return cell
        }
    }
}

extension CardViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if historyButton.isPressed {
            delegate?.didSelectRecord(phoneNumber: arrayOfRecords[indexPath.row].recordNumber)
        }
        else {
            delegate?.didSelectTemplate()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if historyButton.isPressed {
            if editingStyle == .delete {
                arrayOfRecords.remove(at: indexPath.row)
                userDefaults.set(try? PropertyListEncoder().encode(arrayOfRecords), forKey: "Records")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        else {
            if editingStyle == .delete {
                arrayOfTemplates.remove(at: indexPath.row)
                userDefaults.set(arrayOfTemplates, forKey: "Template")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
