//
//  ContentView.swift
//  SwiftPractices
//
//  Created by Mythrai Boga on 16/03/25.
//

import SwiftUI

struct ScratchModel {
    let overlayColor: Color
    let backgroundColor: Color
    let size: CGFloat
}

struct ContentView: View {
    @State var paths = [CGPoint]()
    let model: ScratchModel
    let overlayView: AnyView

    @State private var clearScratchArea = false
    private let gridSize = 5
    private var gridCellSize: CGFloat {
        model.size / 5
    }

    private let scratchClearAmount: CGFloat = 0.5

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: model.size/10)
                .fill(model.overlayColor)
                .frame(width: model.size, height: model.size)

            // MARK: Full REVEAL view
            RoundedRectangle(cornerRadius: model.size/10)
                .fill(model.backgroundColor)
                .frame(width: model.size, height: model.size)
                .overlay {
                    // Add image with party_popper
                    overlayView
                        .scaledToFit()
                        .frame(width: model.size * 0.67, height: model.size * 0.67)

                }
                .compositingGroup()
                .shadow(color: .black, radius: 10)
                .opacity(clearScratchArea ? 1 : 0)


            // MARK: Partial REVEAL view
            RoundedRectangle(cornerRadius: model.size/10)
                .fill(model.backgroundColor)
                .frame(width: model.size, height: model.size)
                .overlay {
                    // Add image with party_popper
                    overlayView
                        .scaledToFit()
                        .frame(width: model.size * 0.67, height: model.size * 0.67)

                }
                .mask (
                    // Add Paths to mask the view
                    Path { path in
                        path.addLines(paths)
                    }
                        .stroke(style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .round))
                )
                // Add drag gesture and add the points to paths
                .gesture(
                    DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        paths.append(value.location)
                        let feedbackGen = UIImpactFeedbackGenerator(style: .soft)
                        feedbackGen.impactOccurred()
                    })
                    .onEnded { value in
                        let cgpath = Path { path in
                            path.addLines(paths)
                        }.cgPath

                        let thickenedPath = cgpath.copy(strokingWithWidth: 50,
                                                        lineCap: .round,
                                                        lineJoin: .round,
                                                        miterLimit: 10)

                        var scratchedCells = 0
                        for i in 0..<gridSize {
                            for j in 0..<gridSize {
                                let point = CGPoint(x: gridCellSize / 2 + gridCellSize * CGFloat(i),
                                                    y: gridCellSize / 2 + gridCellSize * CGFloat(j))
                                if thickenedPath.contains(point) {
                                    scratchedCells += 1
                                }
                            }
                        }
                        // check the scratchedPercentage from gridSize * gridSize
                        let scratchedPercentage = Double(scratchedCells) / Double(gridSize * gridSize)

                        // If scratchedPercentage > scratchClearAmount then clear the scratch area
                        if scratchedPercentage > scratchClearAmount {
                            clearScratchArea = true
                        }
                    }
                )
                .opacity(clearScratchArea ? 0 : 1)
        }
        .padding()
    }
}

#Preview {
    let overlayView = AnyView(
        Image("party_popper", bundle: nil)
        .resizable()
    )
    ContentView(model: ScratchModel(overlayColor: .red,
                                    backgroundColor: .yellow,
                                    size: 200),
                overlayView: overlayView)
}
