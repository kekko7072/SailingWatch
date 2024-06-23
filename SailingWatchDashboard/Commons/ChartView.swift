//
//  ChartView.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import SwiftUI
import Charts

enum ChartType {
    case pie
    case horizontalBar
}

struct ChartView: View {
    var forLocales: [String: Int]
    var chartType: ChartType
    
    var body: some View {
        Chart {
            switch chartType {
            case .pie:
                ForEach(forLocales.sorted(by: >), id: \.key) { key, value in
                    SectorMark(
                        angle: .value("Count", value),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(by: .value("Locale", key))
                    .annotation(position: .overlay) {
                        Text("\(key): \(value)")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
            case .horizontalBar:
                ForEach(forLocales.sorted(by: >), id: \.key) { key, value in
                    BarMark(
                        x: .value("Count", value),
                        y: .value("Locale", key)
                    )
                    .foregroundStyle(by: .value("Locale", key))
                    .annotation(position: .trailing) {
                        Text("\(value)")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

#Preview {
    Group {
        ChartView(forLocales: ["One": 1, "Two": 2], chartType: .pie)
        ChartView(forLocales: ["One": 1, "Two": 2], chartType: .horizontalBar)
    }
}

