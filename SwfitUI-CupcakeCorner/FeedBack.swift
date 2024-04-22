//
//  FeedBack.swift
//  SwfitUI-CupcakeCorner
//
//  Created by JimmyChao on 2024/4/20.
//

import SwiftUI
import CoreHaptics

struct FeedBack: View {
    
    @State private var counter = 0
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        Button("Tap to buzz") {
            counter += 1
        }
        .onAppear{
            prepareEngine()
            composeEvents()
        }
        
    }
    
    // Start the engine
    func prepareEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
    // Compose haptics
    func composeEvents() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 1)
        let sharpeness = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 1)
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpeness],
            relativeTime: 0)
        
        events.append(event)
        
        
        for i in stride(from: 0, to: 10, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    FeedBack()
}
