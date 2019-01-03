//
//  GroupViewController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/31/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var backButton: UIButton!
    var groupLabel: UILabel!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var addButton: UIButton!
    
    let memberList: [String] = ["Francesca", "Eli", "Zumba Group", "Francesca and Eli", "Eli and Zumba", "Family of Four"]
    var matchingMembers: [String]!
    
    let reuseIdentifier = "groupCell"
    let cellHeight: CGFloat = 100
    let cellSpacing: CGFloat = 20
    let buttonOffset: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrowBlack"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissModalView), for: .touchUpInside)
        view.addSubview(backButton)
        
        groupLabel = UILabel()
        groupLabel.text = "Groups"
        groupLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        view.addSubview(groupLabel)
        
        matchingMembers = memberList
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Find a group..."
        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        addButton = UIButton()
        addButton.backgroundColor = .white
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .light)
        addButton.titleLabel?.textAlignment = .center
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = 40
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowRadius = 2
        addButton.layer.masksToBounds = false
        view.addSubview(addButton)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        backButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(buttonOffset)
        }
        groupLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.centerY.equalTo(backButton)
        }
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(groupLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        addButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(80)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchingMembers = searchText.isEmpty ? memberList : memberList.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchingMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupTableViewCell
        cell.configure(members: matchingMembers[indexPath.section])
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
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}
