//
//  ScheduleTableViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 15-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController {
    var weekDayNumber: Int? // Sunday: 1; Saturday: 7
    var semester: Semester?
    var schedules = [Schedule]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.title = "Horario de Hoy"
        
        getSchedules()
        self.tableView.reloadData()
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
        if(schedules.count <= 0){
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            emptyLabel.text = "No hay clases el día de hoy"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        else{
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        return schedules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
        var block: String?
        
        switch(schedules[indexPath.row].block){
            case 1:
                block = "1-2"
                break
            case 2:
                block = "3-4"
                break
            case 3:
                block = "5-6"
                break
            case 4:
                block = "7-8"
                break
            case 5:
                block = "9-10"
                break
            case 6:
                block = "11-12"
                break
            case 7:
                block = "13-14"
                break
            default:
                block = "1-2"
                break
        }

        // Configure the cell...
        cell.block.text = block
        cell.course.text = schedules[indexPath.row].course!.abbreviation

        return cell
    }
    
    func getWeekDay(){
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        weekDayNumber = calendar.component(.weekday, from: date)
    }
    
    func getSchedules(){
        getWeekDay()
        
        let context = getContext()
        let predicate = NSPredicate(format: "course.semester == %@ AND day == %d", semester!, weekDayNumber!)
        let sectionSortDescriptor = NSSortDescriptor(key: "block", ascending: true)
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        do{
            schedules = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
