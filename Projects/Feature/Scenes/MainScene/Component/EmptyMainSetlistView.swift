//
//  EmptyMainSetlistView.swift
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
import Combine

// TODO: 추후 수정하기

struct EmptyMainSetlistView: View {
  @ObservedObject var viewModel: MainViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
      Group {
        Text("세트리스트 정보가 없습니다.")
          .font(.system(size: 16))
          .fontWeight(.semibold)
          .foregroundStyle(Color.mainBlack)
        .multilineTextAlignment(.leading)
        
        Text("찜한 가수의 세트리스트가 없다면,")
          .foregroundStyle(Color.fontGrey2)
          .font(.footnote)
          .padding(.top)
          .multilineTextAlignment(.leading)
        
        if viewModel.isKorean() {
          HStack(spacing: 0) {
            Link(destination: URL(string: "https://www.setlist.fm")!) {
              Text("Setlist.fm")
                .underline()
                .foregroundStyle(Color.fontGrey2)
                .font(.footnote)
            }
            Text("에서 직접 추가할 수 있어요.")
              .foregroundStyle(Color.fontGrey2)
              .font(.footnote)
              .multilineTextAlignment(.leading)
          }
          .padding(.bottom)
        } else {
          HStack(spacing: 0) {
            Text("에서 직접 추가할 수 있어요.")
                        .foregroundStyle(Color.fontGrey2)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
            Link(destination: URL(string: "https://www.setlist.fm")!) {
              Text("Setlist.fm")
                .underline()
                .foregroundStyle(Color.fontGrey2)
                .font(.footnote)
            }
          }
          .padding(.bottom)
        }
      }
      .padding(.horizontal, 3)

      Link(destination: URL(string: "https://www.setlist.fm")!) {
        RoundedRectangle(cornerRadius: 14)
          .foregroundStyle(Color.mainGrey1)
          .frame(height: UIHeight * 0.06)
          .overlay {
            Text("세트리스트 추가하기")
              .foregroundStyle(Color.mainBlack)
              .bold()
          }
          .padding(.top)
      }
      Spacer()
    }
    .frame(width: UIWidth * 0.81)
  }
  
}

#Preview {
  EmptyMainSetlistView(viewModel: MainViewModel())
}
