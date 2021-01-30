//
//  AppDelegate.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Programmatic UI setup (I prefer this to Storyboards)
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: TableViewController())
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: - Core Data stack

    // Setup for Core Data model used to persist Like data
    // Taken as-is, future iterations could handle errors properly
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LikeModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

