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
    var backButton: UIButton!
    var groupNameLabel: UILabel!
    var viewCalendarButton: UIButton!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var group: Group!
    
    var memberList: [String] = ["Michael Jones", "Charles Jones", "Lily Jones", "Anna Ricardo", "Joshua Chen"]
    let photoNames = ["Eli", "Kari", "Danielle", "Abhinav", "Noah", "Olivia"]
    var matchingMembers: [String]!
    
    let addMemberReuseIdentifier = "addCell"
    let memberReuseIdentifier = "memberCell"
    let cellHeight: CGFloat = 80
    let cellSpacing: CGFloat = 5
    let buttonHeight: CGFloat = 50
    
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
        
        groupNameLabel = UILabel()
        groupNameLabel.text = group.groupName
        groupNameLabel.textColor = Colors.labelColor
        groupNameLabel.font = UIFont(name: "Nunito-Regular", size: 30)
        view.addSubview(groupNameLabel)
        
        matchingMembers = memberList
        
        viewCalendarButton = UIButton()
        viewCalendarButton.setTitle("View calendar", for: .normal)
        viewCalendarButton.setTitleColor(.white, for: .normal)
        viewCalendarButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 20)
        viewCalendarButton.backgroundColor = Colors.red
        viewCalendarButton.layer.cornerRadius = buttonHeight / 2
        viewCalendarButton.layer.shadowColor = Colors.shadowColor
        viewCalendarButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        viewCalendarButton.layer.shadowOpacity = 0.8
        viewCalendarButton.layer.masksToBounds = false
        view.addSubview(viewCalendarButton)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        (searchBar.value(forKey: "searchField") as? UITextField)?.backgroundColor = Colors.searchBar
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = Colors.labelColor
        searchBar.placeholder = "Find a user..."
        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: memberReuseIdentifier)
        tableView.register(AddMemberCell.self, forCellReuseIdentifier: addMemberReuseIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)

        setupConstraints()
    }
    
    func setupConstraints() {
        radialGradient.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.height.width.equalTo(30)
        }
        groupNameLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
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
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-MenuBarParameters.menuBarHeight)
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
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}
extension GroupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingMembers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addMemberReuseIdentifier, for: indexPath) as! AddMemberCell
            cell.backgroundColor = .clear
            cell.setNeedsUpdateConstraints()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: memberReuseIdentifier, for: indexPath) as! GroupTableViewCell
            cell.configureWithUser(name: matchingMembers[indexPath.row - 1], photoName: photoNames[indexPath.row - 1])
            cell.backgroundColor = .clear
            cell.setNeedsUpdateConstraints()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.memberList.remove(at: indexPath.row)
            matchingMembers = memberList
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
