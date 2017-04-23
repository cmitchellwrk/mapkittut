//
//  FilterTableViewController.swift
//  mapkittut
//
//  Created by Chris Mitchell on 4/9/17.
//  Copyright © 2017 Chris Mitchell. All rights reserved.
//


import UIKit





class FilterTableViewController: UITableViewController  , PickerFieldsDataHelperDelegate {

    
    @IBOutlet weak var catagoryTextField: UITextField!
    
    @IBOutlet weak var rankingTextField: UITextField!
    
    
    
    
    
    let pickerFieldsDataHelper = PickerFieldsDataHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pickerFieldsDataHelper.delegate = self
        
        pickerFieldsDataHelper.doneButtonTitle = "Choose"
        pickerFieldsDataHelper.defaultFirstItemTitle = "Select an option"
        pickerFieldsDataHelper.needsConfirmationButton = false
        
        pickerFieldsDataHelper.useDefaultFirstItem = true
        pickerFieldsDataHelper.initWithDefaultFirstItemSelected = false
        
        
        
        
        pickerFieldsDataHelper.delegate = self
        
        
        pickerFieldsDataHelper.addDataHelpers([catagoryTextField, rankingTextField], isDateType: false)
        
        
        loadAccountTypeOptions()
        
        
        
    
    }
    
    
    func loadAccountTypeOptions() {
       
        
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Buildings & land rights(e.g.offices)"  , object: 0)
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Fixed equipment & software(e.g.computers)"  , object: 1)
        
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Light factory equipment(e.g. lift trucks)"  , object: 2)
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Office equipment(e.g. desks)"  , object: 3)
        
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Maintenance & repair items(e.g. paint)" , object: 4)
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Maintenance & repair services(e.g. computer repair)" , object: 5)
        
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(catagoryTextField, title: "Business advisory services(e.g. legal, consulting)" , object: 6)
        
        
        
        
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(rankingTextField, title: "thumbs up", object: 0)
        pickerFieldsDataHelper.addTitleAndObjectInDataHelper(rankingTextField, title: "thumbs down", object: 1)
        
        
    }
    
    func pickerFieldsDataHelper(_ dataHelper: PickerDataHelper, didSelectObject selectedObject: Any?, withTitle title: String?) {
        if let title = title, let object = selectedObject {
            
            
         //   print("Selected 1'\(title)' with object: \(object)")
            
            
            
        }
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
        return 4
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        
        
        if (segue.identifier == "SegueMapFilter") {
            
          
            
            let DestViewController = segue.destination as! UINavigationController
            let svc = DestViewController.topViewController as! MapFilterResViewController
            
            
            
                svc.cat = self.catagoryTextField.text!
                
                svc.rank =  self.rankingTextField.text!
                
            
                
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    

}
