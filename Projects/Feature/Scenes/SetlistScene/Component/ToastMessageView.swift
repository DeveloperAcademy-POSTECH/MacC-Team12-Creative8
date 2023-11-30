//
//  ToastMessageView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct ToastMessageView: View {
  let message: LocalizedStringResource
  
  var body: some View {
     Text(message)
      .foregroundStyle(Color.settingTextBoxWhite)
      .font(.subheadline)
      .padding(.vertical, 15)
      .frame(maxWidth: .infinity)
      .background(
        Color.toastBurn
          .cornerRadius(27)
      )
  }
}

#Preview {
  ToastMessageView(message: "1~2분 후 Apple Music에서 확인하세요")
}
