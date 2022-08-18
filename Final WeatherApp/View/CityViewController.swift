//
//  CityViewController.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-15.
//

import UIKit
import CoreData // for NSFetchedResultsController

class CityViewController: UIViewController {
    @IBOutlet weak var savedCityTableView: UITableView!
    
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        savedCityTableView.delegate = self
        savedCityTableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        fetchResult.fetchSavedCityResults()
        fetchResult.fetchedResultsController.delegate = self

    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTVID" {
            let AddCitiesVC = segue.destination as? AddCitiesViewController
            AddCitiesVC?.context = fetchResult.context // pass the NSManagedObject to add AddCitiesVC
        }
    }
}

extension CityViewController : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return fetchedResultsController.sections?.count ?? 1
        return fetchResult.fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return fetchResult.fetchedResultsController.sections?[section].numberOfObjects ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCityCell", for: indexPath) as!
            WeatherTableViewCell
        let city = fetchResult.fetchedResultsController.object(at: indexPath)
        cell.cityNameLabel.text = city.cityName
        cell.cityTempLabel.text = String(city.cityTemp)

        if let url = URL(string: "http://openweathermap.org/img/wn/\(city.weatherIcon ?? "")@2x.png") {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in

                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    DispatchQueue.main.async {
                        cell.img.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let deletedCity = fetchResult.fetchedResultsController.object(at: indexPath)
            fetchResult.context.delete(deletedCity)
            //self.context.delete(deletedCity)
            try? fetchResult.context.save()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension CityViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        var predicate: NSPredicate?
        let bar = searchController.searchBar.text
        print(searchController.searchBar.text!)
        if searchController.isActive {
            if !(bar!.isEmpty){
                predicate = NSPredicate(format: "cityName BEGINSWITH[c] %@", bar!)
                fetchResult.fetchedResultsController.fetchRequest.predicate = predicate
            }
        } else {
            predicate = nil
            savedCityTableView.reloadData()
            fetchResult.fetchSavedCityResults()
        }
        do {
            try fetchResult.fetchedResultsController.performFetch()
            savedCityTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }

    }
}


extension CityViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedCityTableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedCityTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            savedCityTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            savedCityTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            savedCityTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            savedCityTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Aborting")
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            savedCityTableView.insertSections(indexSet, with: .fade)
        case .delete:
            savedCityTableView.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Abort the request")
        @unknown default:
            fatalError("Aborting")
        }
    }
    

}
