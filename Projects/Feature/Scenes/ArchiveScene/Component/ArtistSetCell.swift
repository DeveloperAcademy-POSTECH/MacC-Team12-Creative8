//
//  ArtistSetCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/31/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct ArtistSetCell: View {
   let name: String
   let isSelected: Bool
   var body: some View {
     Text(name)
       .foregroundStyle(isSelected ? Color.settingTextBoxWhite : Color.fontGrey2)
       .padding(10)
       .background {
         let color = isSelected ? Color.mainBlack : Color.mainGrey1
         color.clipShape(RoundedRectangle(cornerRadius: 12))
       }
       .font(.subheadline)
   }
 }

struct AllArtistsSetCell: View {
   let name: LocalizedStringResource
   let isSelected: Bool
   var body: some View {
     Text(name)
       .foregroundStyle(isSelected ? Color.settingTextBoxWhite : Color.fontGrey2)
       .padding(10)
       .background {
         let color = isSelected ? Color.mainBlack : Color.mainGrey1
         color.clipShape(RoundedRectangle(cornerRadius: 12))
       }
   }
 }

 #Preview {
   ArtistSetCell(name: "방탄소년단", isSelected: false)
 }
