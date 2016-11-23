//
//  AddCourseViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 21-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class AddCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var abbreviation: UITextField!
    @IBOutlet weak var credits: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var schedules = [Schedule]()
    let course = Course(context: getContext())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setEditing(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        name.underlined()
        abbreviation.underlined()
        credits.underlined()
        
        let height = min(self.view.bounds.size.height, self.tableView.contentSize.height)
        tableHeightConstraint.constant = height
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddScheduleCell", for: indexPath) as! AddScheduleTableViewCell
        
        var day: String?
        var block: String?
        
        // Day
        switch(schedules[indexPath.row].day){
            case 1:
                day = "Domingo"
                break
            case 2:
                day = "Lunes"
                break
            case 3:
                day = "Martes"
                break
            case 4:
                day = "Miércoles"
                break
            case 5:
                day = "Jueves"
                break
            case 6:
                day = "Viernes"
                break
            case 7:
                day = "Sábado"
                break
            default:
                day = "Lunes"
                break
        }
        
        // Block
        switch(schedules[indexPath.row].block){
            case 1:
                block = "Bloque 1-2"
                break
            case 2:
                block = "Bloque 3-4"
                break
            case 3:
                block = "Bloque 5-6"
                break
            case 4:
                block = "Bloque 7-8"
                break
            case 5:
                block = "Bloque 9-10"
                break
            case 6:
                block = "Bloque 11-12"
                break
            case 7:
                block = "Bloque 13-14"
                break
            default:
                block = "Bloque 1-2"
                break
        }
        
        cell.day.text = day!
        cell.block.text = block!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let context = getContext()
            let schedule = schedules[indexPath.row]
            context.delete(schedule)
            
            schedules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableHeightConstraint.constant = self.tableView.contentSize.height - tableView.rowHeight
            self.view.layoutIfNeeded()
            
            checkSaveButton()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddDaySegue"){
            let button = sender as! UIButton
            let cell = button.superview!.superview!.superview as! UITableViewCell
            let scheduleIndex = tableView.indexPath(for: cell)?.row
            
            let daysNavigationController = segue.destination as! UINavigationController
            let daysController = daysNavigationController.viewControllers[0] as! DaysTableViewController
            daysController.scheduleIndex = scheduleIndex
            daysController.selectedDay = schedules[scheduleIndex!].day
        }
        else if(segue.identifier == "AddBlockSegue"){
            let button = sender as! UIButton
            let cell = button.superview!.superview!.superview as! UITableViewCell
            let scheduleIndex = tableView.indexPath(for: cell)?.row
            
            let blockNavigationController = segue.destination as! UINavigationController
            let blocksController = blockNavigationController.viewControllers[0] as! BlocksTableViewController
            blocksController.scheduleIndex = scheduleIndex
            blocksController.selectedBlock = schedules[scheduleIndex!].block
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        checkSaveButton()
    }
    
    func checkSaveButton(){
        if(name.hasText && abbreviation.hasText && credits.hasText && schedules.count > 0){
            saveButton.isEnabled = true
        }
        else{
            saveButton.isEnabled = false
        }
    }

    @IBAction func onAddSchedule(_ sender: Any) {
        let newSchedule = Schedule(context: getContext())
        newSchedule.course = course
        schedules.append(newSchedule)
        tableView.reloadData()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        checkSaveButton()
    }
    
    @IBAction func onCancelAddDay(segue: UIStoryboardSegue) {
    }
    
    @IBAction func onDoneAddDay(segue: UIStoryboardSegue) {
    }
    
    @IBAction func onCancelAddBlock(segue: UIStoryboardSegue) {
    }
    
    @IBAction func onDoneAddBlock(segue: UIStoryboardSegue) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
