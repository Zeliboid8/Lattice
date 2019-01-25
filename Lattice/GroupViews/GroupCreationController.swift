//
//  GroupCreationController.swift
//  Lattice
//
//  Created by Eli Zhang on 1/24/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

class GroupCreationController: UIViewController, UISearchBarDelegate {
    
    var radialGradient: RadialGradientView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var submitButton: UIButton!
    var group: Group!
    
    let memberList: [String] = []
    var matchingMembers: [String]!
    
    let addMemberReuseIdentifier = "addCell"
    let memberReuseIdentifier = "memberCell"
    let cellHeight: CGFloat = 80
    let cellSpacing: CGFloat = 5
    let submitButtonHeight: CGFloat = 50
    let vOffset: CGFloat = 30
    let hOffset: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        radialGradient = RadialGradientView()
        view.addSubview(radialGradient)
        
        backButton = UIButton()
        if navigationController == nil {
            backButton.setImage(UIImage(named: "DownArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        backButton.imageView?.tintColor = Colors.labelColor
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        view.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = "New Group"
        titleLabel.textColor = Colors.labelColor
        titleLabel.font = UIFont(name: "Nunito-Semibold", size: 40)
        view.addSubview(titleLabel)
        
        matchingMembers = memberList
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        (searchBar.value(forKey: "searchField") as? UITextField)?.backgroundColor = Colors.searchBar
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = Colors.labelColor
        searchBar.placeholder = "Find a friend..."
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
        
        submitButton = UIButton()
        submitButton.setTitle("Create group", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 25)
        submitButton.backgroundColor = Colors.red
        submitButton.layer.cornerRadius = submitButtonHeight / 2
        submitButton.layer.shadowColor = Colors.shadowColor
        submitButton.layer.shadowOffset = CGSize(width: 5, height: 7)
        submitButton.layer.shadowOpacity = 0.8
        submitButton.layer.masksToBounds = false
        submitButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(submitButton)
        
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
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(hOffset)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(vOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        submitButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-vOffset)
            make.leading.trailing.equalTo(view).inset(hOffset)
            make.height.equalTo(submitButtonHeight)
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
    
    @objc func closeView() {
        if navigationController == nil {
            dismissView()
        }
        else {
            popView()
        }
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

extension GroupCreationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchingMembers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addMemberReuseIdentifier, for: indexPath) as! AddMemberCell
            cell.backgroundColor = .clear
            cell.setNeedsUpdateConstraints()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: memberReuseIdentifier, for: indexPath) as! GroupTableViewCell
            cell.configureWithUser(name: matchingMembers[indexPath.section - 1])
            cell.backgroundColor = .clear
            cell.setNeedsUpdateConstraints()
            return cell
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
