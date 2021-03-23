//
//  ContentView.swift
//  File Selector
//
//  Created by Evan Liu on 3/16/21.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State var fileUpload = false
    @State var filepath:[String] = [""]
    @State var fileName:String = ""
    
    @State var toggleState = [Bool]()
    @State var orgEntries
        = [OrgStruct]()
    
    @State var subitemState = [false, false, false, false, false, false, false]
    
    var body: some View {
        VStack{
            NavigationView{
                List{
                    ForEach(Array(orgEntries.enumerated()), id: \.1.id){ index, item in
                        DisclosureGroup(isExpanded: $toggleState[index]){
                            
                            ForEach(Array(item.children.enumerated()), id: \.1.id){ ( subindex, subitem) in
                                
                                DisclosureGroup(isExpanded: $subitemState[subindex]){
                                    Text(subitem.text)
                                }
                                label: {
                                    Text(subitem.header)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation{
                                                self.subitemState[subindex].toggle()
                                            }
                                        }
                                }
                            }
                        }
                        label: {
                            Text(item.header)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation{
                                        self.toggleState[index].toggle()
                                    }
                                }
                        }
                    }
                }
                .navigationTitle(self.fileName)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Upload"){
                           fileUpload.toggle()
                        }
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
            
            .fileImporter(isPresented: $fileUpload, allowedContentTypes: [.orgType]) { (res) in
                do{
                    let data = try res.get();

                    guard let fileName = data.absoluteURL.pathComponents.last else {return}
                    self.fileName = fileName
                    
                    let orgString = try String(contentsOf: data.absoluteURL)
                    var array = orgString.components(separatedBy: "\n")

                    array = array.filter{item in
                        return item.count != 0
                    }
                    
                    var parentHeader:OrgStruct = OrgStruct(header: "")
                    var childrenHeader:OrgStruct = OrgStruct(header: "")
                    
                    var childIndex = -1
                    
                    for (index,item) in array.enumerated() {
                        if item[item.index(item.startIndex, offsetBy:0)] == "*" {
                            let separatorIndex = item.firstIndex(of: " ")!
                            print("----------")
                            print("Index: \(index)")
                            print("Level: \(item[...separatorIndex].trimmingCharacters(in: .whitespaces))")
                            
                            if item[...separatorIndex].trimmingCharacters(in: .whitespaces) == "*" {
                                parentHeader = OrgStruct(header: item[separatorIndex...].trimmingCharacters(in: .whitespaces))
                            }
                            
                            else if item[...separatorIndex].trimmingCharacters(in: .whitespaces) == "**"  {
                                
                                childrenHeader = OrgStruct(header: item[separatorIndex...].trimmingCharacters(in: .whitespaces))
                                
                                if childIndex == -1 {
                                    childIndex = index + 1
                                } else {
                                    childrenHeader.text = array[array.index(array.startIndex, offsetBy: childIndex)...array.index(array.startIndex, offsetBy: index)].joined(separator: "")
                                    parentHeader.addChild(childrenHeader)
                                }
                            } else {
                                
                            }
                            
                            print("Header: \(item[separatorIndex...].trimmingCharacters(in: .whitespaces))")
//                            self.header.append(OrgStruct(header: item[separatorIndex...].trimmingCharacters(in: .whitespaces)))
                            print("----------")
                        }
                    }
                    
                    orgEntries.append(parentHeader)
                    
                    for _ in 1..<self.orgEntries.count+1 {
                        self.toggleState.append(false)
                    }
                } catch {
                    print("error")
                }
            }
        }
    }
}

extension UTType {
    public static let orgType = UTType(filenameExtension: "org", conformingTo: .data)!
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
