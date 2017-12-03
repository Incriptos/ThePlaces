//
//  PlacesTableViewController.swift
//  ThePlaces
//
//  Created by Андрей Вашуленко on 01.10.17.
//  Copyright © 2017 Andrew Vashulenko. All rights reserved.
//

import UIKit
import CoreData

class PlacesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchResultsController: NSFetchedResultsController<Place>!
    var searchController:  UISearchController!
    var filteredResultArray: [Place] = []
    var places: [Place] = []
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func filterContentFor(searchText text: String) {
        
        filteredResultArray = places.filter{ (place) -> Bool in
            return(place.name?.lowercased().contains(text.lowercased()))!
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      searchController = UISearchController(searchResultsController: nil)
      searchController.searchResultsUpdater = self
      searchController.dimsBackgroundDuringPresentation = false
      tableView.tableHeaderView = searchController.searchBar
      searchController.searchBar.delegate = self
      searchController.searchBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // Black Search Bar
      searchController.searchBar.tintColor = .red // Цвет Шрифта
        // Серч контроллер не будет переходить на некст экран
      definesPresentationContext = true
        
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Self Sizing Cell
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Создаю запрос (ФэтсРеквест) с описанием
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Добираюсь до контекста и создаю его
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
              try fetchResultsController.performFetch()
              places = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
              print(error.localizedDescription)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefault = UserDefaults.standard
        let wasIntroWatched = userDefault.bool(forKey: "wasIntroWatched")
        guard !wasIntroWatched else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Fetch Result Controller Delegate
    
    // Предупреждаю тейблВью что сейчас будет череда изменений
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        
        places = controller.fetchedObjects as! [Place]
    }
    
    // Говорю ТейблВью что череда изменений закончена
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        } else {
            return places.count
        }
    }

    func placeToDisplayAt(indexPath: IndexPath) -> Place {
        let place: Place
        if searchController .isActive && searchController.searchBar.text != "" {
            place = filteredResultArray[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        return place
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesTableViewCell
        
        let place = placeToDisplayAt(indexPath: indexPath)
        
        cell.thumbnailView.image = UIImage(data: place.image! as Data)
        cell.thumbnailView.layer.cornerRadius = 32.5
        cell.thumbnailView.clipsToBounds = true
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        cell.accessoryType = place.isVisited ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            
            let defaultText = "Я сейчас в " + self.places[indexPath.row].name!
            if let image = UIImage(data: self.places[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
    
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            self.places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                  try context.save()
                } catch {
                  print(error.localizedDescription)
                }
                
            }
        }
        
        share.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return [delete, share]
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destanationViewController = segue.destination as! PlacesDetailViewController
                destanationViewController.place = placeToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

extension PlacesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
        
    }
    
}

extension PlacesTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}










