//
//  PlacesDetailViewController.swift
//  ThePlaces
//
//  Created by Андрей Вашуленко on 05.10.17.
//  Copyright © 2017 Andrew Vashulenko. All rights reserved.
//

import UIKit

class PlacesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateButton: UIButton!
    
    var place: Place?
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let sourceViewController = segue.source as? RateViewController else { return }
        guard let rating = sourceViewController.placeRating else { return }
        rateButton.setImage(UIImage(named: rating), for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableViewAutomaticDimension
        
        imageView.image = UIImage(data: place!.image! as Data)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = place!.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = place!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = place!.type
        case 2:
            cell.keyLabel.text = "Локация"
            cell.valueLabel.text = place!.location
        case 3:
            cell.keyLabel.text = "Я там был?"
            cell.valueLabel.text = place!.isVisited ? "Yes" : "No"
        default:
            break
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.place = self.place
        }
    }
    
}
