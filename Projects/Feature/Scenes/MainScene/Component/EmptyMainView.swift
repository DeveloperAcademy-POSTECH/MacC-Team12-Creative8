//
//  EmptyMain.swift
//  Feature
//
//  Created by 장수민 on 11/4/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI

struct EmptyMainView: View {
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack {
      Spacer()
      Text("찜한 아티스트가 없습니다")
        .font(.callout)
        .padding(.bottom)
        .foregroundStyle(Color.mainBlack)
      Group {
        VStack {
          Text("관심있는 아티스트 정보를 빠르게")
          Text("확인하고 싶으시다면 찜을 해주세요")
        }
      }
        .font(.footnote)
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.fontGrey2)
        .padding(.bottom)
      Button {
        selectedTab = .search
      } label: {
        HStack {
          Text("아티스트 찜하러 가기")
          Image(systemName: "magnifyingglass")
        }
        .bold()
        .foregroundStyle(Color.mainWhite)
        .font(.system(size: 14))
        .padding(EdgeInsets(top: 17, leading: 22, bottom: 17, trailing: 22))
        .background(RoundedRectangle(cornerRadius: 14)
          .foregroundStyle(Color.buttonBlack))
      }
      .padding(.vertical)
      Spacer()
    }
  }
}
