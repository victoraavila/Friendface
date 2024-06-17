//
//  CustomDividerView.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftUI

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.gray)
            .padding(.vertical)
    }
}

#Preview {
    CustomDividerView()
}
