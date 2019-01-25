//
//  Group.swift
//  Lattice
//
//  Created by Eli Zhang on 1/25/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

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

