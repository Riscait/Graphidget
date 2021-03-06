//
//  DetailChartView.swift
//  Graphidget
//
//  Created by 村松龍之介 on 2020/10/31.
//

import SwiftUI
import SharedObjects

struct DetailChartView: View {

    let chart: ChartModel

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CircularChartView(
                chartData: chart,
                entryLabelEnabled: true,
                centerTextEnabled: true,
                legendEnabled: true,
                selectionShift: 16
            )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct DetailChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailChartView(chart: chartModelStab)
            DetailChartView(chart: chartModelStab)
                .environment(\.colorScheme, .dark)
        }
    }
}
