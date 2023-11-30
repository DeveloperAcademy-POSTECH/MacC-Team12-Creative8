//
//  SetlistFMLinkButtonView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct SetlistFMLinkButtonView: View {
  var body: some View {
    VStack {
      if let url = URL(string: "https://www.setlist.fm") {
        Link(destination: url) {
          Text("세트리스트 추가하기")
            .foregroundStyle(Color.mainBlack)
            .font(.callout)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.fontGrey3)
            .cornerRadius(14)
        }
      }
    }
  }
}

#Preview {
    SetlistFMLinkButtonView()
}
