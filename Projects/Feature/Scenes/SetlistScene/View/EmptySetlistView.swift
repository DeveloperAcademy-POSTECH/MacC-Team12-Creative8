//
//  EmptySetlistView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct EmptySetlistView: View {
  var body: some View {
    VStack {
      Text("세트리스트가 없습니다")
        .font(.callout)
        .fontWeight(.semibold)
        .foregroundStyle(Color.mainBlack)
        .padding(.bottom)
        .padding(.top, 100)
      
      Group {
        Text("세트리스트를 직접 작성하고 싶으신가요?")
        Text("Setlist.fm에서 추가해보세요.")
      }
      .foregroundStyle(Color.fontGrey2)
      .font(.footnote)
      .multilineTextAlignment(.center)
      SetlistFMLinkButtonView()
        .padding(.top, 100)
    }
  }
}

#Preview {
    EmptySetlistView()
}
