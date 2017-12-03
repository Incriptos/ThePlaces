//
//  RateViewController.swift
//  ThePlaces
//
//  Created by Андрей Вашуленко on 05.10.17.
//  Copyright © 2017 Andrew Vashulenko. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {
    @IBOutlet weak var goodRateButton: UIButton!
    @IBOutlet weak var badRateButton: UIButton!
    @IBOutlet weak var veryGoodRateButton: UIButton!
    
    var placeRating: String?
    
    @IBAction func rateThePlace(sender: UIButton) {
        
        switch sender.tag {
        case 0: placeRating = "goodRate"
        case 1: placeRating = "veryGoodRate"
        case 2: placeRating = "badRate"
        default:
            break
        }
        
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let buttonArray = [goodRateButton, veryGoodRateButton, badRateButton]
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.7, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        badRateButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodRateButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        veryGoodRateButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.insertSubview(blurEffectView, at: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
