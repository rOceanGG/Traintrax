//
//  DelayReport.swift
//  Traintrax
//
//  Created by Roshan Gani Ganithi on 10/06/2025.
//
import Foundation

struct Line: Decodable {
    let id: String
    let name: String
    let lineStatuses: [LineStatus]
}

struct LineStatus: Decodable, Identifiable {
    var id: UUID { UUID() }  // Unique ID for SwiftUI lists
    let lineId: String
    let statusSeverity: Int
    let statusSeverityDescription: String
    let reason: String?
    let disruption: Disruption?
}

struct Disruption: Decodable {
    let category: String
    let categoryDescription: String
    let description: String
    let additionalInfo: String?
    let closureText: String
}
