//
//  Utilities.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 13-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit
import CoreData

func getContext() -> NSManagedObjectContext{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}
