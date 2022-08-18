//
//  fetchResultController.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-14.
//

import Foundation
import CoreData
import UIKit

// This struct written in purpose of keeping the controller classes clean from the NSFetchedResultsController
struct fetchResult {

    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var fetchedResultsController: NSFetchedResultsController<CityWeather>!
    
    static func fetchSavedCityResults() {

        let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "cityName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: "cityName",
                                                              cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}
