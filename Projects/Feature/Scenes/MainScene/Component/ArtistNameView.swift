//
//  HorizontalArtistNameScrollView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

struct ArtistNameView: View {
  @Binding var selectedTab: Tab
  @ObservedObject var viewModel: MainViewModel
  var index: Int
  var name: String
  
  var body: some View {
    HStack(spacing: 0) {
      Text(.init(name))
        .font(.title)
        .fontWeight(.semibold)
    }
    .foregroundColor(viewModel.selectedIndex == index ? Color.mainBlack : Color.fontGrey3)
  }
}

#Preview {
  ArtistNameView(selectedTab: .constant(.home),
                 viewModel: MainViewModel(),
                 index: 1, name: "Silica Gel")
}
