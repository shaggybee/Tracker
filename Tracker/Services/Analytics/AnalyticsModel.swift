//
//  AnalyticsModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.06.2026.
//



struct AnalyticsModel {
    let screen: AnalyticsScreen
    let event: AnalyticsEvent
    let item: AnalyticsItem?
    
    init(screen: AnalyticsScreen, event: AnalyticsEvent, item: AnalyticsItem? = nil) {
        self.screen = screen
        self.event = event
        self.item = item
    }
}
