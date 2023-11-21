//
//  ArchiveArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct ArchiveArtistCell: View {
  let artistUrl: URL?
  let isNewUpdate: Bool
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    Group {
      if let url = artistUrl {
        AsyncImage(url: artistUrl) { image in
          image
            .centerCropped()
        } placeholder: {
          ProgressView()
        }
      } else {
        if colorScheme == .light {
          Image(uiImage: UIImage(named: "whiteTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .stroke(Color.mainGrey1, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
            )
        } else {
          Image(uiImage: UIImage(named: "darkTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .stroke(Color.mainGrey1, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
            )
        }
      }
    }
    .aspectRatio(1.0, contentMode: .fit)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .frameForCell()
  }
}

#Preview {
  ArchiveArtistCell(artistUrl: URL(string: "https://newsimg.sedaily.com/2019/10/11/1VPHATB1H9_1.jpg")!,
                    isNewUpdate: true)
}
