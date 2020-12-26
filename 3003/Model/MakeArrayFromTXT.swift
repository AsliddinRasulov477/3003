//
//  MakeArrayFromTXT.swift
//  3000
//
//  Created by Asliddin Rasulov on 10/12/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import Foundation
import UIKit

var indexTR: Int = 0

class MakeArrayFromTXT {
    
    var indexColumn: Int = 0
    
    var rowArray: [[String]] = []
    
    var xomColumn: [String] = []
    var debetColumn: [String] = []
    var kreditColumn: [String] = []
    var ythColumn: [String] = []
    
    var inXOMColunm: [String] = []

    func getFileToArray(fileName: String) -> [[String]] {
        
        if let path = Bundle.main.path(forResource: (fileName + "file").localized, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                return getRows(fullArray: myStrings)
            } catch {
                print(error)
            }
        }
        return []
    }

    private func getRows(fullArray: [String]) -> [[String]] {
        for i in fullArray.indices {
            if fullArray[i] != "" {
                getcolumns(fullRow: fullArray[i])
            }
        }
        rowArray = [xomColumn, debetColumn, kreditColumn, ythColumn, inXOMColunm]
        return rowArray
    }

    private func getcolumns(fullRow: String) {
        let arrSplit = fullRow.split(separator: "\t")
        
        if checkTRcolumn(checkee: String(arrSplit[0])) {
            
            indexColumn += 1
    
            xomColumn.append("\(indexColumn)Ω" + String(arrSplit[1]))
            
            if arrSplit.count == 5  {
                indexTR += 1
                debetColumn.append("\(indexTR)∫" + String(arrSplit[2]))
                kreditColumn.append(String(arrSplit[3]))
                ythColumn.append(String(arrSplit[4]))
            } else {
                debetColumn.append("0")
                kreditColumn.append("0")
                ythColumn.append(String(arrSplit[2]))
            }
            
        } else {
            indexTR += 1
            inXOMColunm.append("\(indexColumn)Ω" + String(arrSplit[0]) + "Ω" + "\(indexTR)∫" + String(arrSplit[1]) + "Ω" + String(arrSplit[2]))
        }
        
    }
    
    private func checkTRcolumn(checkee: String) -> Bool {
        if Int(checkee) != nil {
            return true
        }
        return false
    }
}
