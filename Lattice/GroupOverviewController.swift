//
//  GroupOverviewController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/31/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class GroupOverviewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var radialGradient: RadialGradientView!
    var groupLabel: UILabel!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var addButton: UIButton!
    
    let groupList: [Group] = [Group(groupMembers: ["Satomi Kikunaga"]),
                               Group(groupName: "Parents", groupMembers: ["Charles Jones", "Anna Ricardo"]),
                               Group(groupMembers: ["Ellen", "Juan", "Rachael"]),
                               Group(groupName: "Math Study Group", groupMembers: ["Anthony Perez", "Daniel Heinz-Klarmann"]),
                               Group(groupName: "Jones Family", groupMembers: ["Michael Jones", "Charles Jones", "Anna Ricardo"]),
                               Group(groupMembers: ["Anna Ricardo"])]
    var matchingGroups: [Group]!
    
    let reuseIdentifier = "groupCell"
    let cellHeight: CGFloat = 100
    let cellSpacing: CGFloat = 5
    let buttonOffset: CGFloat = 25
    let searchBarColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
    let labelColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        groupLabel = UILabel()
        groupLabel.text = "Groups"
        groupLabel.textColor = labelColor
        groupLabel.font = UIFont(name: "Nunito-Regular", size: 40)
        view.addSubview(groupLabel)
        
        matchingGroups = groupList
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        (searchBar.value(forKey: "searchField") as? UITextField)?.backgroundColor = searchBarColor
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = labelColor
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
        
        addButton = UIButton()
        addButton.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.38, alpha: 1)
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 50)
        addButton.titleLabel?.textAlignment = .center
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = 40
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowRadius = 2
        addButton.layer.masksToBounds = false
        view.addSubview(addButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        groupLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(groupLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20 - MenuBarParameters.menuBarHeight)
        }
        addButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(80)
            make.trailing.equalTo(view).offset(-40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40 - MenuBarParameters.menuBarHeight)
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
        return cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupController = GroupController()
        groupController.setGroup(group: groupList[indexPath.section])
        present(groupController, animated: true, completion: nil)
    }
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

class Group {
    var groupName: String!
    var groupMembersString: String!
    var groupMembers: [String]!
    var groupSearchText: String!
    var hasName: Bool!
    
    init(groupName: String, groupMembersString: String, groupMembers: [String]) {
        self.groupName = groupName
        self.groupMembersString = groupMembersString
        self.groupMembers = groupMembers
        self.groupSearchText = String("\(groupName) \(groupMembersString)")
        self.hasName = true
    }
    init(groupName: String, groupMembers: [String]) {
        self.groupMembersString = groupMembers.first
        if groupMembers.count > 1 {
            if groupMembers.count > 2 {
                for i in 1..<groupMembers.count - 1 {
                    self.groupMembersString.append(", \(groupMembers[i])")
                }
                self.groupMembersString.append(", and \(groupMembers.last ?? "")")
            }
            else {
                self.groupMembersString.append(" and \(groupMembers.last ?? "")")
            }
        }
        self.groupName = groupName
        self.groupMembers = groupMembers
        self.groupSearchText = String("\(groupName) \(groupMembersString ?? "")")
        self.hasName = true
    }
    
    init(groupMembers: [String]) {
        self.groupMembersString = groupMembers.first
        if groupMembers.count > 1 {
            if groupMembers.count > 2 {
                for i in 1..<groupMembers.count - 1 {
                    self.groupMembersString.append(", \(groupMembers[i])")
                }
                self.groupMembersString.append(", and \(groupMembers.last ?? "")")
            }
            else {
                self.groupMembersString.append(" and \(groupMembers.last ?? "")")
            }
        }
        self.groupName = groupMembersString
        self.groupMembers = groupMembers
        self.groupSearchText = groupMembersString
        self.hasName = false
    }
}
