import SwiftUI
import Foundation

struct CircularProgressView: View {
    let value: Double
    var total: Double = 100

    var body: some View {
        let progress = value / total
        ZStack {
//            Circle()
//                    .stroke(
//                            Color.blue.opacity(0.1),
//                            lineWidth: 10
//                    )
            Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                            Color.black,
                            style: StrokeStyle(
                                    lineWidth: 10,
                                    lineCap: .round
                            )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)

        }
    }
}
