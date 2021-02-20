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
}

class CardViewController: UIViewController {

    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var templatesButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleBackground: UIView!
    
    @IBOutlet weak var descriptionBackground: UIView!
    
    let userDefaults = UserDefaults.standard
    var arrayOfRecords = [HistoryRecord]()
    var delegate:CardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let encodedData = userDefaults.value(forKey:"Records") as? Data {
            arrayOfRecords = try! PropertyListDecoder().decode([HistoryRecord].self, from: encodedData)
        }
        
        titleLable.text = "Chat History"
        descriptionLable.text = "Your recent operations will be shown here.\nYou can start your chat by tapping on it."
        
        historyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        
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
        return arrayOfRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.flageImage.image = arrayOfRecords[indexPath.row].recordImage.getImage()
        cell.numberLable.text = arrayOfRecords[indexPath.row].recordNumber
        cell.dateLable.text = arrayOfRecords[indexPath.row].recordDate
        
        let kind = userDefaults.object(forKey: K.Theme.currentTheme) as? String
        cell.baseView.backgroundColor = UIColor(named: "\(kind!)\(K.Card.backgroundColor)")
        cell.numberLable.textColor = UIColor(named: "\(kind!)\(K.TextField.textColor)")
        cell.dateLable.textColor = UIColor(named: "\(kind!)\(K.TextField.textColor)")
        return cell
    }
}

extension CardViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectRecord(phoneNumber: arrayOfRecords[indexPath.row].recordNumber)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayOfRecords.remove(at: indexPath.row)
            userDefaults.set(try? PropertyListEncoder().encode(arrayOfRecords), forKey: "Records")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
