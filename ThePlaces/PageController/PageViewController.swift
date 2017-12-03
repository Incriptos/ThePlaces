//
//  PageViewController.swift
//  ThePlaces
//
//  Created by Андрей Вашуленко on 10.10.17.
//  Copyright © 2017 Andrew Vashulenko. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var headersArray = ["Записывайте", "Находите"]
    var subheadersArray = ["Создайте и поделитесь своим списком любимых заведений", "Найдите и укажите локацию на карте ваших любимых заведений"]
    var imagesArray = ["letsgodrink.png", "mapicon.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = displayViewController(atIndex: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayViewController(atIndex index: Int ) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier:
            "contentViewController") as? ContentViewController else { return nil }
        
        contentViewController.imageFile = imagesArray[index]
        contentViewController.header = headersArray[index]
        contentViewController.subheader = subheadersArray[index]
        contentViewController.index = index
        
        return contentViewController
    }
    
    func nextViewController(atIndex index: Int) {
        if let contentViewController =  displayViewController(atIndex: index + 1) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//            return contentViewController!.index
//    }
}






