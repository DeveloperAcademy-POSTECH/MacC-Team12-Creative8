//
//  IsEmptyCell.swift
//  Feature
//
//  Created by A_Mcflurry on 11/2/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct IsEmptyCell: View {
  enum EmptyType {
    case bookmark
    case likeArtist
  }
  let type: EmptyType
  var body: some View {
    VStack {
      Text(type == .bookmark ? "북마크 한 공연이 없어요" : "찜한 아티스트가 없어요")
        .font(.headline)
        .foregroundStyle(Color.mainBlack)
        .padding(.bottom, 12)
      Group {
        Text(type == .bookmark ? "관심있는 공연을 북마크하고" : "관심있는 아티스트를 찜하고")
        Text(type == .bookmark ? "빠르게 세트리스트를 확인해보세요" : "공연 및 세트리스트 정보를 빠르게 확인해보세요")
      }
      .font(.footnote)
      .foregroundStyle(Color.fontGrey2)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .multilineTextAlignment(.center)
  }
}

#Preview {
  IsEmptyCell(type: .bookmark)
}
