//
//  FriendController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/25/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

class FriendController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var radialGradient: RadialGradientView!
    var backButton: UIButton!
    var friendsLabel: UILabel!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    let groupList: [Group] = [Group(groupMembers: ["Satomi Kikunaga"]),
                              Group(groupName: "Parents", groupMembers: ["Charles Jones", "Anna Ricardo"]),
                              Group(groupMembers: ["Ellen", "Juan", "Rachael"]),
                              Group(groupName: "Math Study Group", groupMembers: ["Anthony Perez", "Daniel Heinz-Klarmann"]),
                              Group(groupName: "Jones Family", groupMembers: ["Michael Jones", "Charles Jones", "Anna Ricardo"]),
                              Group(groupMembers: ["Anna Ricardo"])]
    var matchingGroups: [Group]!
    
    let reuseIdentifier = "groupCell"
    let cellHeight: CGFloat = 80
    let cellSpacing: CGFloat = 5
    let buttonOffset: CGFloat = 25
    let searchBarColor = Colors.searchBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.imageView?.tintColor = Colors.labelColor
        backButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        view.addSubview(backButton)
        
        friendsLabel = UILabel()
        friendsLabel.text = "Friends"
        friendsLabel.textColor = Colors.labelColor
        friendsLabel.font = UIFont(name: "Nunito-Regular", size: 40)
        view.addSubview(friendsLabel)
        
        matchingGroups = groupList
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        (searchBar.value(forKey: "searchField") as? UITextField)?.backgroundColor = searchBarColor
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = Colors.labelColor
        searchBar.placeholder = "Find a group..."
        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(30)
        }
        friendsLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(friendsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-MenuBarParameters.menuBarHeight)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchingGroups = searchText.isEmpty ? groupList : groupList.filter { (item: Group) -> Bool in
            return item.groupSearchText.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchingGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupTableViewCell
        cell.configureWithGroup(group: matchingGroups[indexPath.section])
        cell.backgroundColor = .clear
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupController = GroupController()
        groupController.setGroup(group: groupList[indexPath.section])
        navigationController?.pushViewController(groupController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}
