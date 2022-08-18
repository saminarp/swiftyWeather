//
//  AddCitiesViewController.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-14.
//

import UIKit
import CoreData
class AddCitiesViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var city = ""
    
    lazy var searchCityTableVC = self.storyboard?.instantiateViewController(withIdentifier: "searchCityTableID") as! SearchResultsTableViewController
    lazy var searchController = UISearchController(searchResultsController: searchCityTableVC)
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<CityWeather>!
    
    func setUpFetchedResultsController() {
        
       let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
       let sortDescriptor = NSSortDescriptor(key: "cityName", ascending: true)
       fetchRequest.sortDescriptors = [sortDescriptor]
       
       fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: "cityName",
                                                             cacheName: nil)
       fetchedResultsController.delegate = self
       do {
           try fetchedResultsController.performFetch()
       } catch {
           print("The fetch could not be performed: \(error.localizedDescription)")
       }
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.searchController = searchController
        searchCityTableVC.delegate = self
        //=searchController
        title = "Search city"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        setUpFetchedResultsController()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Action to save NSManagedObject
    @IBAction func saveTapped(_ sender: Any) {
        let cityObj = CityWeather(context: context)
        
        cityObj.cityName = self.city
        Service.shared.performFetchWeather(with: APICall.openweather(cityObj.cityName!).stringURL) { data in
            cityObj.cityTemp = data.temperature //temp
            cityObj.weatherIcon = data.icon // icon
            try? self.context.save() //saving to the coredata
        }
        self.dismiss(animated: true, completion: nil)

    }
}



extension AddCitiesViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            guard let url = URL(string: APICall.geobytes(searchText).stringURL) else{return}
            guard searchText.count > 2 else {
                searchCityTableVC.searchCityList.removeAll()
                searchCityTableVC.tableView.reloadData()
                return
            }
           _ =  Service.shared.searchForCity(url: url) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.searchCityTableVC.searchCityList = data ?? [""]
                self.searchCityTableVC.tableView.reloadData()
           }
        }
    }
}

extension AddCitiesViewController : SearchTableCityDelegate {
    func selected(city: String) {
        let cityName = city.components(separatedBy: ",")[0]
        title = cityName
        self.city = cityName
        searchController.isActive = false
    }
}


