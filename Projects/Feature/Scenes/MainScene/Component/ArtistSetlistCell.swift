//
//  ArtistContentBlock.swift
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

struct ArtistSetlistCell: View {
  @StateObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  
  var dateAndMonth: String
  var year: String
  var city: String
  var country: String
  var firstSong: String
  var setlistId: String
  var artistInfo: ArtistInfo
  var body: some View {
    NavigationLink {
      SetlistView(setlistId: setlistId, artistInfo: artistInfo)
    } label: {
      HStack {
        VStack(alignment: .center) {
          Text(year)
            .foregroundStyle(Color.fontGrey25)
            .tracking(0.5)
          Text(dateAndMonth)
            .foregroundStyle(Color.mainBlack)
        }
        .font(.headline)
        Spacer()
          .frame(width: UIWidth * 0.08)
        VStack(alignment: .leading) {
          Text(city + ", " + country)
            .font(.subheadline)
            .foregroundStyle(Color.mainBlack)
            .lineLimit(1)
          Group {
            if firstSong == "세트리스트 정보가 아직 없습니다" {
              Text(.init(firstSong), comment: "메인화면 공연 세트리스트 없을 때")
            } else {
              Text("01 \(firstSong)")
            }
          }
          .font(.footnote)
          .lineLimit(1)
          .foregroundStyle(Color.fontGrey25)
          
        }
        .foregroundStyle(Color.mainBlack)
        Spacer()
      }
      .padding()
    }
  }
}
