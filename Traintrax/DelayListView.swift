//
//  DelayListView.swift
//  Traintrax
//
//  Created by Roshan Gani Ganithi on 10/06/2025.
//
import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct DelayListView: View {
    @StateObject var viewModel = DelayViewModel()

    // List of all lines (could also be dynamic)
    let lines = ["Bakerloo", "Central", "Circle", "District", "Elizabeth", "Hammersmith and City", "Jubilee", "Metropolitan", "Northern", "Piccadilly", "Victoria", "Waterloo and City"]
    let lineIDs = ["bakerloo", "central", "circle", "district", "elizabeth", "hammersmith-city", "jubilee", "metropolitan", "northern", "picadilly", "victoria", "waterloo-city"]
    let lineColours: [Color] = [
        Color(hex: "#B36305"),  // Bakerloo
        Color(hex: "#E32017"),  // Central
        Color(hex: "#FFD300"),  // Circle
        Color(hex: "#00782A"),  // District
        Color(hex: "#6950A1"),  // Elizabeth
        Color(hex: "#F3A9BB"),  // Hammersmith and City
        Color(hex: "#A0A5A9"),  // Jubilee
        Color(hex: "#9B0056"),  // Metropolitan
        Color(hex: "#000000"),  // Northern
        Color(hex: "#003688"),  // Piccadilly
        Color(hex: "#0098D4"),  // Victoria
        Color(hex: "#95CDBA"),  // Waterloo and City
    ]
    
    var body: some View {
        NavigationView {
            List(Array(zip(lines.indices, lines)), id: \.1) { index, line in
                VStack(spacing: 0) {
                    NavigationLink(destination: LineDelaysView(lineID: lineIDs[index], lineName: lines[index], viewModel: viewModel)) {
                        Text("\(lines[index]) Line")
                            .font(.headline)
                            .foregroundColor(lineColours[index])
                            .padding(.vertical, 8)
                    }
                    Rectangle()
                        .fill(lineColours[index])
                        .frame(height: 2)
                        .edgesIgnoringSafeArea(.horizontal)
                }
            }
            .navigationTitle("Train Lines")
        }
    }
}
// New view to show delays for a specific line
struct LineDelaysView: View {
    let lineID: String
    let lineName: String
    @ObservedObject var viewModel: DelayViewModel
    
    var body: some View {
        let delays = viewModel.allDelays.filter { $0.lineId == lineID }
        Group {
            if delays.isEmpty {
                AnyView(
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                        Text("No disruptions on this line!")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                )
            } else {
                AnyView(
                    List(delays) { delay in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(delay.statusSeverityDescription)")
                            if let dreason = delay.reason {
                                let sep = dreason.split(separator: ":")
                                let actual = sep.count > 1 ? String(sep[1].dropFirst()) : dreason
                                Text(actual)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                )
            }
        }
        .navigationTitle("\(lineName) Delays")
        .onAppear {
            viewModel.fetchDelays(for: lineID)
        }
    }
}
