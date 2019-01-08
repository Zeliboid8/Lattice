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

    let calendarController = BlockCalendarController()
    let eventController = DocumentScannerController()
    let homeController = HomeController()
    let groupOverviewController = GroupOverviewController()
    var groupNavigationController: UINavigationController!
    let profileController = ProfileController()
    var viewControllers: [UIViewController]!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var loggedIn: Bool = false
    
    var menuBar: MenuBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        groupNavigationController = UINavigationController(rootViewController: groupOverviewController)
        groupNavigationController.setNavigationBarHidden(true, animated: false)
        
        calendarController.view.tag = 0
        eventController.view.tag = 1
        homeController.view.tag = 2
        groupNavigationController.view.tag = 3
        profileController.view.tag = 4
        viewControllers = [calendarController, eventController, homeController, groupNavigationController, profileController]

        menuBar = MenuBar()
        menuBar.delegate = self
        view.addSubview(menuBar)
        
        view.addSubview(homeController.view)
        view.sendSubviewToBack(homeController.view)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loggedIn {
            presentLogin()
            loggedIn = true
        }
    }
    
    func setupConstraints() {
        menuBar.snp.makeConstraints { (make) -> Void in
            make.bottom.leading.trailing.equalTo(view)
            make.height.equalTo(MenuBarParameters.menuBarHeight)
        }
    }

    func presentLogin() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
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
