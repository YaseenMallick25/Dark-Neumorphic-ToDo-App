//
//  DarkButtonStyle.swift
//  Drink Up
//
//  Created by Yaseen Mallick on 05/05/20.
//  Copyright © 2020 Yaseen Mallick. All rights reserved.
//

import SwiftUI

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10)
            .contentShape(Circle())
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
    }
}

struct DarkButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
