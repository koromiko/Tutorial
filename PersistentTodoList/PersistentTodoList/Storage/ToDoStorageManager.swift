//
//  ToDoStorageManager.swift
//  PersistentTodoList
//
//  Created by Neo on 02/09/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ToDoStorgeManager {
    
    let persistentContainer: NSPersistentContainer!
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    //MARK: CRUD
    func insertTodoItem( name: String, finished: Bool ) -> ToDoItem? {

        guard let toDoItem = NSEntityDescription.insertNewObject(forEntityName: "ToDoItem", into: backgroundContext) as? ToDoItem else { return nil }
        toDoItem.name = name
        toDoItem.finished = finished
        
        return toDoItem
    }
    
    func fetchAll() -> [ToDoItem] {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [ToDoItem]()
    }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
        
    }
    
}
