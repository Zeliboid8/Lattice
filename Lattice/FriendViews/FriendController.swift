//
//  FriendController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/25/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class FriendController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var radialGradient: RadialGradientView!
    var backButton: UIButton!
    var friendsLabel: UILabel!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var addButton: UIButton!
    var groupList: [Group] = [Group(groupMembers: ["Satomi Kikunaga"]),
                              Group(groupName: "Parents", groupMembers: ["Charles Jones", "Anna Ricardo"]),
                              Group(groupMembers: ["Ellen", "Juan", "Rachael"]),
                              Group(groupName: "Math Study Group", groupMembers: ["Anthony Perez", "Daniel Heinz-Klarmann"]),
                              Group(groupName: "Jones Family", groupMembers: ["Michael Jones", "Charles Jones", "Anna Ricardo"]),
                              Group(groupMembers: ["Anna Ricardo"])]
    let photoNames = ["Eli", "Kari", "Danielle", "Abhinav", "Noah", "Olivia"]
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
        searchBar.placeholder = "Search for a user..."
        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        addButton = UIButton()
        addButton.backgroundColor = Colors.red
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 50)
        addButton.titleLabel?.textAlignment = .center
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = 40
        addButton.layer.shadowColor = Colors.shadowColor
        addButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowRadius = 2
        addButton.layer.masksToBounds = false
//        addButton.addTarget(self, action: #selector(presentAddGroupView), for: .touchUpInside)
        view.addSubview(addButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
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
        addButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(80)
            make.trailing.equalTo(view).offset(-35)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-45 - MenuBarParameters.menuBarHeight)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchingGroups = searchText.isEmpty ? groupList : groupList.filter { (item: Group) -> Bool in
            return item.groupSearchText.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingGroups.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FriendTableViewCell
        cell.configureWithGroup(group: matchingGroups[indexPath.row], photoName: photoNames[indexPath.row])
        cell.backgroundColor = .clear
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.groupList.remove(at: indexPath.row)
            matchingGroups = groupList
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupController = GroupController()
        groupController.setGroup(group: groupList[indexPath.row])
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
