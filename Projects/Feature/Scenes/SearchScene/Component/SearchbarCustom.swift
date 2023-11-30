//
//  UISearchbarCustom.swift
//  Feature
//
//  Created by A_Mcflurry on 10/8/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct SearchBar: View {
  @Binding var text: String
  @Binding var isEditing: Bool
  var placeholder: LocalizedStringResource = "아티스트를 검색하세요"
  
  init(text: Binding<String>, isEditing: Binding<Bool>) {
    self._text = text
    self._isEditing = isEditing
  }
  
  var body: some View {
    HStack {
      TextField("", text: $text, prompt: Text(placeholder))
        .autocorrectionDisabled(true)
        .padding(7)
        .padding(.horizontal, 34)
        .foregroundColor(.fontGrey2)
        .background(Color.mainGrey1)
        .cornerRadius(10)
        .overlay(
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.fontGrey2)
              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 16)
            
            if isEditing && text.count != 0 {
              Button {
                self.text = ""
              } label: {
                Image(systemName: "multiply.circle.fill")
                  .foregroundColor(.fontGrey2)
                  .padding(.trailing, 7.5)
              }
            }
          }
        )
        .onTapGesture {
          withAnimation {
            self.isEditing = true
          }
        }
      
      if isEditing {
        Button("취소") {
          withAnimation {
            self.isEditing = false
            self.text = ""
          }
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .foregroundStyle(Color.mainBlack)
        .padding(.horizontal, 10)
      }
    }
    .textCase(.none)
    .padding(.bottom, 20)
  }
}
