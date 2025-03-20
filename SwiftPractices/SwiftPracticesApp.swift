//
//  SwiftPracticesApp.swift
//  SwiftPractices
//
//  Created by Mythrai Boga on 16/03/25.
//

import SwiftUI

@main
struct SwiftPracticesApp: App {
    var body: some Scene {
        WindowGroup {
            let overlayView = AnyView(
                Image("party_popper", bundle: nil)
                    .resizable()
            )
            ContentView(model: ScratchModel(overlayColor: .red, backgroundColor: .yellow, size: 200),
                        overlayView: overlayView)
        }
    }
}
