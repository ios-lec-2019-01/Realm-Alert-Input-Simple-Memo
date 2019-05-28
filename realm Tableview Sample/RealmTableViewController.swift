//
//  DBTableViewController.swift
//  realm Tableview Sample
//
//  Created by 김종현 on 23/05/2019.
//  Copyright © 2019 김종현. All rights reserved.
//

import UIKit
import RealmSwift

class Memo : Object {
    @objc dynamic var content: String = ""
    @objc dynamic var date = Date()
}

class RealmTableViewController: UITableViewController {
    
    // 데이터베이스 객체 생성
    let realm = try! Realm()
    var memoArray: Results<Memo>?
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        f.locale = Locale(identifier: "KO_kr")
        return f
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var txtField = UITextField()
        
        let alertController = UIAlertController(title: "add new", message:"" , preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action: UIAlertAction) in
            let new = Memo()
            new.content = txtField.text!
            self.save(memo: new)
        }
        
        alertController.addTextField { (alertTextField: UITextField) in
            txtField = alertTextField
        }
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func save(memo: Memo) {
        print("save")
        do {
            try realm.write {
                realm.add(memo)
            }
        } catch {
            print("error")
        }
        self.tableView.reloadData()
        //print(personArray)
    }
    
    func loadData() {
        memoArray = realm.objects(Memo.self)
        self.tableView.reloadData()
    }
    
    @IBAction func deleteData(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        memoArray = realm.objects(Memo.self)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 1
        return (memoArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        cell.textLabel?.text = memoArray?[indexPath.row].content ?? "no data"
        cell.detailTextLabel?.text = formatter.string(from: Date())
        
        //cell.detailTextLabel?.text = formatter.string(from: (personArray?[indexPath.row].date)!)
        return cell
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let realm = try! Realm()
            try! realm.write {
                realm.delete(memoArray![indexPath.row])
            }
            
            memoArray = realm.objects(Memo.self)
            self.tableView.reloadData()
            
         } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
