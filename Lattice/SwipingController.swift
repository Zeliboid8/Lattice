//
//  SwipingController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/27/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit

class SwipingController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var viewControllersToDisplay: [UIViewController] = [TextSelectionController(), ViewController(), CalendarController()]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let firstViewController = viewControllersToDisplay[1]
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersToDisplay.index(of: viewController) else { return nil }
        if index == 0 { return nil }
        return viewControllersToDisplay[abs((index - 1) % viewControllersToDisplay.count)]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersToDisplay.index(of: viewController) else { return nil }
        if index == viewControllersToDisplay.count - 1 { return nil }
        return viewControllersToDisplay[abs((index + 1) % viewControllersToDisplay.count)]
    }
}
