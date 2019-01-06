//
//  GroupController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/4/19
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class GroupController: UIViewController, UISearchBarDelegate {
    
    var radialGradient: RadialGradientView!
    var groupNameLabel: UILabel!
    var viewCalendarButton: UIButton!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var addButton: UIButton!
    var group: Group!
    
    let memberList: [String] = ["Michael Jones", "Charles Jones", "Lily Jones", "Anna Ricardo", "Joshua Chen"]
    var matchingMembers: [String]!
    
    let reuseIdentifier = "groupCell"
    let cellHeight: CGFloat = 100
    let cellSpacing: CGFloat = 5
    let buttonOffset: CGFloat = 25
    let searchBarColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
    let labelColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    let buttonHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        groupNameLabel = UILabel()
        groupNameLabel.text = group.groupName
        groupNameLabel.textColor = labelColor
        groupNameLabel.font = UIFont(name: "Nunito-Regular", size: 40)
        view.addSubview(groupNameLabel)
        
        matchingMembers = memberList
        
        viewCalendarButton = UIButton()
        viewCalendarButton.setTitle("View calendar", for: .normal)
        viewCalendarButton.setTitleColor(.white, for: .normal)
        viewCalendarButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        viewCalendarButton.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.38, alpha: 1)
        viewCalendarButton.layer.cornerRadius = buttonHeight / 2
        viewCalendarButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        viewCalendarButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        viewCalendarButton.layer.shadowOpacity = 0.8
        viewCalendarButton.layer.masksToBounds = false
        view.addSubview(viewCalendarButton)
        
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
        groupNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        viewCalendarButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(40)
            make.height.equalTo(buttonHeight)
        }
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewCalendarButton.snp.bottom).offset(20)
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
    
    func setGroup(group: Group) {
        self.group = group
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchingMembers = searchText.isEmpty ? memberList : memberList.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}
extension GroupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchingMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupTableViewCell
        cell.configureWithUser(name: matchingMembers[indexPath.section])
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
}
