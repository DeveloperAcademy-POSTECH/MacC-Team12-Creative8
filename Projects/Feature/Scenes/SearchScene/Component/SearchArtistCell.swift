//
//  SearchArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/8/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI
import Core

struct SearchArtistCell: View {
  @Binding var selectedTab: Tab
  let imageURL: String
  let artistName: String
  let artistAlias: String
  let artistMbid: String
  let artistGid: Int
  
  var body: some View {
    VStack(alignment: .leading) {
      NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: artistName, country: "", alias: artistAlias, mbid: artistMbid, gid: artistGid, imageUrl: imageURL, songList: []))) {
        AsyncImage(url: URL(string: imageURL)) { phase in
          switch phase {
          case .empty:
            RoundedRectangle(cornerRadius: 20)
              .foregroundStyle(Color.mainGrey1)
              .overlay(
                Image("ticket", bundle: setaBundle)
                  .resizable()
                  .renderingMode(.template)
                  .foregroundStyle(Color.lineGrey1)
                  .scaledToFill()
                  .frame(width: UIWidth * 0.2, height: UIWidth * 0.2)
              )
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
          case .failure:
            RoundedRectangle(cornerRadius: 20)
              .foregroundStyle(Color.mainGrey1)
              .overlay(
                Image("ticket", bundle: setaBundle)
                  .resizable()
                  .renderingMode(.template)
                  .foregroundStyle(Color.lineGrey1)
                  .scaledToFill()
                  .frame(width: UIWidth * 0.2, height: UIWidth * 0.2)
              )
          @unknown default:
            EmptyView()
          }
        }
      }
      .aspectRatio(contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.lineGrey1, lineWidth: 1))
      
      Text("\(artistName)")
        .foregroundStyle(Color.mainBlack)
        .font(.footnote)
        .lineLimit(1)
    }
  }
}
