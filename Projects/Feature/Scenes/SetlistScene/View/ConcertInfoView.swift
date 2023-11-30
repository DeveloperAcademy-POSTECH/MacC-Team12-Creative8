//
//  ConcertInfoView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct ConcertInfoView: View {
  var artist: String
  var date: String
  var venue: String
  var tour: String
  
  var body: some View {
    VStack {
      Group {
        Text("\(artist) ")
          .foregroundStyle(Color.mainBlack)
        +
        Text("Setlist")
          .foregroundStyle(Color.fontGrey2)
      }
      .font(.largeTitle)
      .fontWeight(.semibold)
      .frame(maxWidth: .infinity, alignment: .leading)
      
      InfoComponent(text1: "날짜", text2: date)
      InfoComponent(text1: "장소", text2: venue)
      InfoComponent(text1: "공연", text2: tour)
      
    }
  }
}

struct InfoComponent: View {
  let text1: LocalizedStringResource
  let text2: String
  
  var body: some View {
    HStack {
      Text(text1)
        .foregroundStyle(Color.mainBlack)
        .padding(12)
        .background(Color.mainGrey1.cornerRadius(12))
      Spacer()
      Text(text2)
        .font(.body)
        .foregroundStyle(Color.mainBlack)
        .frame(width: UIWidth * 0.5, alignment: .leading)
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
    ConcertInfoView(artist: "", date: "", venue: "", tour: "")
}
