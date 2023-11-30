//
//  ArtistImage.swift
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

struct ArtistImage: View {
  @Binding var selectedTab: Tab
  var imageUrl: String
  
  var body: some View {
    VStack {
      Group {
        if !imageUrl.isEmpty {
          AsyncImage(url: URL(string: imageUrl)) { image in
            image
              .resizable()
              .scaledToFill()
              .overlay {
                artistImageOverlayButton
                  .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
              }
              .clipShape(RoundedRectangle(cornerRadius: 15))
              .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.mainGrey1, lineWidth: 1))
          } placeholder: {
            ProgressView()
          }
        } else {
          artistEmptyImage
        }
      }
      .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
    }
  }
  
  public var artistEmptyImage: some View {
    RoundedRectangle(cornerRadius: 15)
      .foregroundStyle(Color.mainGrey1)
      .overlay(
        Image("ticket", bundle: setaBundle)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(Color.lineGrey1)
          .aspectRatio(contentMode: .fit)
          .frame(width: UIWidth * 0.43)
      )
      .overlay {
        artistImageOverlayButton
      }
      .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
  }
  
  public var artistImageOverlayButton: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Circle()
          .frame(width: UIWidth * 0.15)
          .foregroundStyle(Color.mainBlack)
          .overlay {
            Image(systemName: "arrow.right")
              .font(.title3)
              .foregroundStyle(Color.settingTextBoxWhite)
          }
          .shadow(color: Color.mainWhite.opacity(0.25), radius: 20, y: 4)
      }
    }
    .padding([.trailing, .bottom])
  }
}

#Preview {
  ArtistImage(selectedTab: .constant(.home), imageUrl: "https://images-prod.dazeddigital.com/1428/azure/dazed-prod/1320/4/1324149.jpeg")
}
