//
//  SearchHistoryDelegate.swift
//  SoftxpertTask
//
//  Created by Macbook on 28/01/2022.
//

import Foundation
protocol SearchHistoryDelegate {
    //delegate if user select from history search
 func getSearchResultFromHistory(selectedSearchHistory:String)
}
