//
//  ExportPlaylistButtonView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ExportPlaylistButtonView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastAppleMusic: Bool
  @Binding var showToastCapture: Bool
  @ObservedObject var exportViewModel: ExportPlaylistViewModel

  var body: some View {
    VStack {
      Spacer()
      
      Group {
        if showToastAppleMusic {
          ToastMessageView(message: "1~2분 후 Apple Music에서 확인하세요")
        } else if showToastCapture {
          ToastMessageView(message: "캡쳐된 사진을 앨범에서 확인하세요")
        }
      }
      .padding(.horizontal, 30)
      
      Button(action: {
        vm.createArrayForExportPlaylist(setlist: setlist, songList: artistInfo?.songList ?? [], artistName: artistInfo?.name)
        vm.showModal.toggle()
      }, label: {
        Text("플레이리스트 내보내기")
          .foregroundStyle(Color.settingTextBoxWhite)
          .font(.callout)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .background(Color.mainBlack)
          .cornerRadius(14)
          .padding(.horizontal, 30)
          .padding(.bottom, 50)
          .background(Rectangle().foregroundStyle(Gradient(colors: [.backgroundWhite.opacity(0), .backgroundWhite, .backgroundWhite])))
      })
    }
    .sheet(isPresented: $vm.showModal) {
      BottomModalView(setlist: setlist, artistInfo: artistInfo, exportViewModel: exportViewModel, vm: vm, showToastAppleMusic: $showToastAppleMusic, showToastCapture: $showToastCapture)
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
    }
  }
}
