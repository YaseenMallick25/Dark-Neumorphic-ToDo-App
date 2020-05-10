//
//  SimpleButtonStyle.swift
//  Music ++
//
//  Created by Yaseen Mallick on 10/05/20.
//  Copyright © 2020 Yaseen Mallick. All rights reserved.
//

import SwiftUI

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding(15)
        .background(
            Group {
                if configuration.isPressed {
                    Circle()
                    .fill(Color.offWhite)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 8)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                    )
                } else {
                    Circle()
                        .fill(Color.offWhite)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                }
            }
        )
    }
}


struct SimpleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Text ("HELLO")
    }
}
