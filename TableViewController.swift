//
//  TableViewController.swift
//  mapkittut
//
//  Created by Chris Mitchell on 4/1/17.
//  Copyright © 2017 Chris Mitchell. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth





class TableViewController: UITableViewController {

    
    var ref: FIRDatabaseReference!
    
 
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("locations")
    
    
    
    
    
       let listToUsers = "ListToUsers"
    
      var items: [Location] = []
  
    
    var userCountBarButtonItem: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        FIRDatabase.database().reference().child("locations").observe(.value, with: {(snapshot) in
        
            
            var newItems: [Location] = []
            
         
            
            
            for item in snapshot.children {
                
                let locat = Location(snapshot: item as! FIRDataSnapshot)
                
                
                newItems.append(locat)
                
                
                
            }
            
 
        
        
            
            self.items = newItems
            
            
            self.tableView.reloadData()
        })
        
        
        
        
        
        
    
        
        
        
             
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    @IBAction func unwindSaveEdit(sender: UIStoryboardSegue, segue: UIStoryboardSegue) {
        
        if(segue.identifier == "unwindSave_Edit"){
            
            
            
            if let sourceViewController = sender.source as? EditTableViewController {
                let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
                
                
                
                
                
                
               
                
                let userID22: String = sourceViewController.locationid
                
                
                             
                
                    self.ref = FIRDatabase.database().reference()
                
                
                self.ref?.child("locations/\(userID22)/address").setValue(sourceViewController.addressTextField.text)
                
                self.ref?.child("locations/\(userID22)/lat").setValue(sourceViewController.latitudeTextField.text)
                
                self.ref?.child("locations/\(userID22)/lon").setValue(sourceViewController.longitudeTextField.text)
                
                self.ref?.child("locations/\(userID22)/catag").setValue(sourceViewController.catagoryTextField.text)
                
                self.ref?.child("locations/\(userID22)/name").setValue(sourceViewController.nameTextField.text)
                
                self.ref?.child("locations/\(userID22)/locationid").setValue(sourceViewController.locationid)
                
                self.ref?.child("locations/\(userID22)/userid").setValue(userID)
                
                self.ref?.child("locations/\(userID22)/ranking").setValue(sourceViewController.rankingTextField.text)
                
                self.ref?.child("locations/\(userID22)/name").setValue(sourceViewController.nameTextField.text)
                
                
                
                
            }
            
            
        }
    }
    

    
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        return 1
        
        
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.items.count
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    
        
        let Location = items[indexPath.row]
        
        cell.textLabel?.text = Location.namee
       
    
        
        
        
     
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        
        return true
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt
        
        indexPath: IndexPath) {
        
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            
            let Location = items[indexPath.row]
   
            let locateid = Location.locationid
            
            
            
            // handle delete (by removing the data from your array and updating the tableview)
         
          //  if let exerciseName = exercises[indexPath.row].exerciseName {
                
                let ref = FIRDatabase.database().reference().child("locations")
                
                ref.queryOrdered(byChild: "locationid").queryEqual(toValue: locateid).observe(.childAdded, with: { (snapshot) in
                    
                    snapshot.ref.removeValue(completionBlock: { (error, reference) in
                        if error != nil {
                            print("There has been an error:\(String(describing: error))")
                        }
                    })
                    
                })
            
           // }
            
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            
            
            
        }
        
        
    }
    
    
   // override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
      //  let selectedProgram = items[indexPath.row]
        
        // Create an instance of PlayerTableViewController and pass the variable
      
        
      //  self.performSegue(withIdentifier: "SegueEdit", sender: self)
        
        
 //   }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       // if (segue.identifier == "SegueEdit") {
            
          //  let controller = (segue.destinationViewController as! UINavigationController).topViewController as! QuestionnaireController
            
            
           // let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
            
           // let patientQuestionnaire = patientQuestionnaires[row] as! PatientQuestionnaire
            
           // controller.selectedQuestionnaire = patientQuestionnaire
            
       // }
        
        if (segue.identifier == "SegueEdit") {
            
            // let svc = segue!.destination as! DetailTableViewController;
            
            let DestViewController = segue.destination as! UINavigationController
            let svc = DestViewController.topViewController as! EditTableViewController
            
            // let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
          //
             if let indexPath =  tableView.indexPathForSelectedRow {
                
                
             let patientQuestionnaire = items[indexPath.row]
            
             svc.lat = patientQuestionnaire.lat
            
            svc.lon = patientQuestionnaire.lon
            
            svc.addr = patientQuestionnaire.address
                
              svc.locationid = patientQuestionnaire.locationid
                
                
                svc.ranking = patientQuestionnaire.ranking
                
                svc.cat = patientQuestionnaire.catag
                
                svc.name = patientQuestionnaire.namee
                
                
            }
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
