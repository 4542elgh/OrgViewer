//
//  OrgStruct.swift
//  File Selector
//
//  Created by Evan Liu on 3/19/21.
//

import Foundation

class OrgStruct: Identifiable {
    var id = UUID()
    var header: String
    var text: String
    var parent: OrgStruct?
    var children: [OrgStruct]
    
    init(header:String, text: String? = nil) {
        self.header = header
        if let unwrappedText = text {
            self.text = unwrappedText
        } else {
            self.text = ""
        }
        self.children = []
    }
    
    func addChild(_ childNode: OrgStruct){
        self.children.append(childNode)
        childNode.parent = self
    }
    
    
}
