//
//  TableViewController.swift
//  ToDoListApp
//
//  Created by Ahmed El-Desouky on 9/24/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit

//عشان نستدعي ال"coreData"
import CoreData

class TableViewController: UITableViewController,UITextFieldDelegate {
//ال"UITextFieldDelegate" عشان نقدر نخفي الkeboard بزرار الreturn
   
    // اخفاء الkeyboard
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
  
    //اخفاء الstatusBar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //بنعرف المصفوفة اللي هيتعرض داخلها الnotes من نوع string ولما نيجي نعمل الcoredata بنغيرها لNSManagedObject
    var note:[NSManagedObject]=[]
    
    @IBAction func addBtn(_ sender: Any) {
        
//بنضيف الAlertTextField داخل الBtn
        
        let alert=UIAlertController(title: "New Note", message: "Please Add Your New Note To Confirm", preferredStyle: .alert)
        let ConfirmAction=UIAlertAction(title: "Confirm", style: .default) { (Action) in
            let notess=(alert.textFields?.first)?.text
            self.save(item: notess!)
            self.tableView.reloadData()
            
        }
        let CancelAction=UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(ConfirmAction)
        alert.addAction(CancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//بنعرف دالة جديدة خاصة بالCoreData داخلها الattribute من نوع String
    func save(item:String) {
        
//بنحط جواها الform بتاع الcoredata اللي عندنا
        
         let  Connection=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let New=NSEntityDescription.insertNewObject(forEntityName: "Notes", into: Connection)
        
        New.setValue(item, forKey: "item")
        
        
        do{
           // let newrege=try connection.fetch(NSFetchRequest<NSFetchRequestResult>(entityName:"Notes"))
            
            try Connection.save()
            note.append(New)
        }
        catch{
            print("error")
        }
       
        
    }
    
//داخل الviwedidload بنعرف المتغير اللي هيسترجع الداتا
    override func viewDidLoad() {
        super.viewDidLoad()
        let  Connection=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            note=try Connection.fetch(NSFetchRequest<NSFetchRequestResult>(entityName:"Notes")) as! [NSManagedObject]
        }
        catch {
            print("nono")
        }
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return note.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

       let notes=note[indexPath.row]
        cell.textLabel?.text=notes.value(forKeyPath: "item") as! String
        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           note.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
