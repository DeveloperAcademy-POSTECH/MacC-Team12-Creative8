//
//  SearchHistoryCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct SearchHistoryCell: View {
  @Binding var searchText: String
  @Binding var selectedTab: Tab
  let history: SearchHistory
  let dataManager: SwiftDataManager
  
  var body: some View {
    VStack {
      HStack {
        NavigationLink {
          ArtistView(selectedTab: $selectedTab, artistName: history.artistInfo.name, artistAlias: history.artistInfo.alias, artistMbid: history.artistInfo.mbid)
        } label: {
          ListRow(namePair: (history.artistInfo.name, ""), info: history.artistInfo.country)
        }
        
        Spacer()
        
        Button {
          dataManager.deleteSearchHistory(history)
        } label: {
          Image(systemName: "xmark")
            .foregroundStyle(Color.fontGrey25)
            .padding(.trailing, 12)
        }
      }
      .padding(.top)
      
      Divider()
        .foregroundStyle(Color.lineGrey1)
        .padding(.top, 15)
    }
  }
}
