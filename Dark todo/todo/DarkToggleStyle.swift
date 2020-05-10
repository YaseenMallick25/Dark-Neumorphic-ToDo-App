//
//  DarkToggleStyle.swift
//  Drink Up
//
//  Created by Yaseen Mallick on 05/05/20.
//  Copyright © 2020 Yaseen Mallick. All rights reserved.
//

import SwiftUI

struct DarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            DarkBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}



struct DarkToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        DarkBackground(isHighlighted: false, shape: Circle())
    }
}
