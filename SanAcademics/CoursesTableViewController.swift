//
//  CoursesTableViewController.swift
//  SanAcademics
//
//  Created by Hernán Raúl Herreros Niño on 14-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

class CoursesTableViewController: UITableViewController {
    var semester: Semester?
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.tabBarController?.navigationItem.title = "Asignaturas"
        getCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem
        self.tabBarController?.navigationItem.title = "Asignaturas"
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
        return courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseTableViewCell
        
        // Configure the cell...
        cell.course.text = courses[indexPath.row].name
        cell.average.text = String(describing: courses[indexPath.row].average!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailCourseSegue"){
            let navigationController = segue.destination as! UINavigationController
            let courseDetailController = navigationController.viewControllers[0] as! CourseDetailViewController
            let cell = sender as! CourseTableViewCell
            let index = tableView.indexPath(for: cell)!.row
            
            courseDetailController.course = courses[index]
            courseDetailController.navigationItem.title = courses[index].name
        }
    }
    
    func getCourses(){
        let context = getContext()
        let predicate = NSPredicate(format: "semester == %@", semester!)
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
            courses = try context.fetch(fetchRequest)
        }
        catch{
            print("Request error: \(error)")
        }
    }
    
    @IBAction func onCancelAddCourse(segue: UIStoryboardSegue) {
        getContext().rollback()
    }
    
    @IBAction func onSaveAddCourse(segue: UIStoryboardSegue) {
        let addCourseController = segue.source as! AddCourseViewController
        
        let name = addCourseController.name.text
        let abbreviation = addCourseController.abbreviation.text
        let credits = addCourseController.credits.text
        
        let context = getContext()
        
        addCourseController.course.name = name
        addCourseController.course.abbreviation = abbreviation
        addCourseController.course.credits = Int16(credits!)!
        addCourseController.course.semester = semester
        
        do{
            try context.save()
            
            let newIndexPath = IndexPath(row: self.courses.count, section: 0)
            self.courses.append(addCourseController.course)
            self.tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func onDeleteCourse(segue: UIStoryboardSegue) {
        let courseDetailController = segue.source as! CourseDetailViewController
        
        // Delete course
        let context = getContext()
        let course = courseDetailController.course!
        let index = courses.index(of: course)!
        
        context.delete(course)
        do{
            try context.save()
            
            courses.remove(at: index)
            self.tableView.reloadData()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.localizedDescription)")
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
