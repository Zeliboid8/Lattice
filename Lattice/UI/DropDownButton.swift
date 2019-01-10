//
//  DropDownButton.swift
//  Lattice
//
//  Created by Eli Zhang on 1/7/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit

protocol DropDownProtocol: class {
    func dropDownPressed(cellTitle: String)
}

protocol DropDownData: class {
    func itemSelected(sender: DropDownButton, contents: String)
}

// Used NSLayoutConstraints for this portion because couldn't animate SnapKit constraints
// Tutorial from Jared Davidson at https://www.youtube.com/watch?v=22zu-OTS-3M
class DropDownButton: UIButton, DropDownProtocol {

    weak var delegate: DropDownData?
    var dropView: DropDownView!
    var height = NSLayoutConstraint()
    let padding: CGFloat = 10
    var isOpen = false
    var addedToSuperview = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setTitleColor(Colors.labelColor, for: .normal)
        setImage(UIImage(named: "DownArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        contentMode = .scaleAspectFit
        imageView?.tintColor = Colors.labelColor
        titleLabel?.font = UIFont(name: "Nunito-Regular", size: 18)
        titleLabel?.textColor = Colors.labelColor
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        
        dropView = DropDownView(frame: .zero)
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = super.imageRect(forContentRect: contentRect)
        
        return CGRect(x: padding,
                      y: contentRect.midY - imageRect.height / 2 + padding,
                      width: imageRect.height - 2 * padding, height: imageRect.height - 2 * padding)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = self.imageRect(forContentRect: contentRect)
        let titleRect = super.titleRect(forContentRect: contentRect)
        
        return CGRect(x: imageRect.width + padding,
                      y: contentRect.midY - titleRect.height / 2,
                      width: contentRect.width - padding * 2 - imageRect.width, height: titleRect.height)
    }
    
    override func didMoveToSuperview() {
//        self.superview?.addSubview(dropView)
//        self.superview?.bringSubviewToFront(dropView)
//        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isOpen {
            if !addedToSuperview {
                self.superview?.addSubview(dropView)
                self.superview?.bringSubviewToFront(dropView)
                dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
                height = dropView.heightAnchor.constraint(equalToConstant: 0)
                addedToSuperview = true
            }
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dropDownPressed(cellTitle: String) {
        setTitle(cellTitle, for: .normal)
        delegate?.itemSelected(sender: self, contents: cellTitle)
        self.dismissDropDown()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: DropDownProtocol?

    var tableView: UITableView!
    var dropDownOptions: [String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        addSubview(tableView)
        dropDownOptions = [String]()
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = Colors.dropDownCell
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = Colors.labelColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dropDownPressed(cellTitle: dropDownOptions[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
