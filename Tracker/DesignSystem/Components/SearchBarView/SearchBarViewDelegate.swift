//
//  SearchBarViewDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

import Foundation

protocol SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didChange text: String)
}
