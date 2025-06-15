//
//  DelayViewModel.swift
//  Traintrax
//
//  Created by Roshan Gani Ganithi on 10/06/2025.
//
import Foundation

class DelayViewModel: ObservableObject {
    @Published var allDelays: [LineStatus] = []
    
    func fetchDelays(for line: String) {
        guard let url = URL(string: "https://api.tfl.gov.uk/Line/\(line)/Status") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("No data or error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let lines = try JSONDecoder().decode([Line].self, from: data)
                var reports: [LineStatus] = []
                for lineObj in lines {
                    for status in lineObj.lineStatuses {
                        if status.disruption != nil {
                            reports.append(
                                LineStatus(
                                    lineId: status.lineId,
                                    statusSeverity: status.statusSeverity,
                                    statusSeverityDescription: status.statusSeverityDescription,
                                    reason: status.reason,
                                    disruption: Disruption(
                                        category: status.disruption?.category ?? "",
                                        categoryDescription: status.disruption?.categoryDescription ?? "",
                                        description: status.disruption?.description ?? "",
                                        additionalInfo: status.disruption?.additionalInfo ?? "",
                                        closureText: status.disruption?.closureText ?? ""
                                    )
                                )
                            )
                        }
                        else{
                            reports.append(
                                LineStatus(
                                    lineId: status.lineId,
                                    statusSeverity: status.statusSeverity,
                                    statusSeverityDescription: status.statusSeverityDescription,
                                    reason: "",
                                    disruption: nil
                                )
                            )
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.allDelays = reports
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
