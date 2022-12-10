import SwiftUI
import Foundation

struct CircularProgressView: View {
    let value: Double
    var total: Double = 100
    var strokeColor: Color = Color.black

    var body: some View {
        let progress = value / total
        ZStack {
            Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                            strokeColor,
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
