//
//  MenuBarController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/6/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

protocol ChangeView: class {
    func changeView(indexPath: IndexPath)
}

struct MenuBarParameters {
    static let menuBarHeight: CGFloat = 70
}

class MenuBarController: UIViewController {

    let calendarController = WeekAvailabilityController()
    let eventController = DocumentScannerController()
    let homeController = HomeController()
    let groupController = GroupOverviewController()
    let profileController = ProfileController()
    var viewControllers: [UIViewController]!
    
    var menuBar: MenuBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        calendarController.view.tag = 0
        eventController.view.tag = 1
        homeController.view.tag = 2
        groupController.view.tag = 3
        profileController.view.tag = 4
        
        viewControllers = [calendarController, eventController, homeController, groupController, profileController]

        menuBar = MenuBar()
        menuBar.delegate = self
        view.addSubview(menuBar)
        
        view.addSubview(homeController.view)
        view.sendSubviewToBack(homeController.view)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        menuBar.snp.makeConstraints { (make) -> Void in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(MenuBarParameters.menuBarHeight)
        }
    }

}

extension MenuBarController: ChangeView {

    func changeView(indexPath: IndexPath) {
        for view in self.view.subviews {
            if view != menuBar && view.tag != indexPath.section {
                view.removeFromSuperview()
            }
        }
        view.addSubview(viewControllers[indexPath.section].view)
        view.sendSubviewToBack(viewControllers[indexPath.section].view)
    }
}
