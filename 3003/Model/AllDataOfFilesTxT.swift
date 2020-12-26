//
//  AllDataOfTxts.swift
//  3003
//
//  Created by Asliddin Rasulov on 25/10/20.
//

import Foundation
import UIKit


class AllDataOfFilesTxT {
    
    func getAllDataToArray() -> [[[String]]] {
        var allDataArray: [[[String]]] = []
        for i in docNamesArray.indices {
            let array = MakeArrayFromTXT().getFileToArray(fileName: docNamesArray[i])
            allDataArray.append(array)
        }
        return allDataArray
    }
    
    func getAllDocsName() -> [String] {
        var allDocsArray: [String] = []
        allDocsArray.append(contentsOf: ActiveSegmentFirstModel().getActiveSegmentFirstSections())
        allDocsArray.append(contentsOf: ActiveSegmentSecondModel().getActiveSegmentSecondSections())
        allDocsArray.append(contentsOf: PassiveSegmentFirstModel().getPassiveSegmentFirstSections())
        allDocsArray.append(contentsOf: PassiveSegmentSecondModel().getPassiveSegmentSecondSections())
        allDocsArray.append(contentsOf: TransitModel().getTransitSections())
        allDocsArray.append(contentsOf: OutOfBalanceModel().getOutOfBalance())
        
        return allDocsArray
    }

    func getOneFileArray(docName: String) -> [[String]] {
        var indexDoc: Int = 0
        for i in docNamesArray.indices {
            if docName == docNamesArray[i] {
                indexDoc = i
            }
        }
        return allDataArray[indexDoc]
    }
}
