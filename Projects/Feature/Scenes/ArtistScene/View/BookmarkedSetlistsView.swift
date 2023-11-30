//
//  BookmarkedSetlistsView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct BookmarkedSetlistsView: View {
  @ObservedObject var vm: ArtistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @State var bookmarkedSetlists: [ArchivedConcertInfo] = []
  @Environment(\.dismiss) var dismiss
  @Binding var selectedTab: Tab
  @State var showBookmarkedSetlists: Bool = false
  
  var body: some View {
    VStack {
      titleLayer
      if showBookmarkedSetlists {
        VStack {
          if bookmarkedSetlists.isEmpty {
            emptyLayer
              .padding(.vertical, 20)
          } else {
            setlistsLayer
            navigationLayer
          }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(
          Color.mainGrey1
            .cornerRadius(15)
        )
        .padding(.horizontal)
      }
    }
    .onAppear {
      getBookmarkedSetlists()
      if !bookmarkedSetlists.isEmpty {
          showBookmarkedSetlists = true
      }
    }
  }
  
  private func getBookmarkedSetlists() {
    bookmarkedSetlists = []
    for concert in concertInfo {
      if concert.artistInfo.mbid == vm.artistInfo.mbid {
        bookmarkedSetlists.append(concert)
      }
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("북마크한 공연")
        .font(.headline)
        .fontWeight(.bold)
      Spacer()
      Button {
//        withAnimation(Animation.spring()) { // MARK: 애니메이션 넣을까요 말까요?
          showBookmarkedSetlists.toggle()
//        }
      } label: {
        Image(systemName: "chevron.right")
          .rotationEffect(.degrees(showBookmarkedSetlists ? 90 : 0))
            .font(.title3)
      }
      .foregroundStyle(Color.mainBlack)
    }
    .padding(EdgeInsets(top: 20, leading: 24, bottom: 24, trailing: 24))
  }
  
  private var emptyLayer: some View {
    VStack(alignment: .center) {
      Text("북마크한 공연이 없습니다.")
        .font(.headline)
        .padding(.bottom)
        .foregroundStyle(Color.mainBlack)
      Group {
        Text("관심있는 공연에 북마크를 눌러 표시해주세요")
        Text("보관함에서도 볼 수 있습니다")
      }
      .font(.footnote)
      .foregroundStyle(Color.fontGrey2)
    }
  }
  
  private var setlistsLayer: some View {
    ForEach(Array(bookmarkedSetlists.prefix(3)), id: \.self) { concert in
      HStack {
        Spacer()
        
        // MARK: Date
        VStack {
          Text(vm.getFormattedDateFromDate(date: concert.setlist.date, format: "yyyy"))
            .foregroundStyle(Color.fontGrey25)
            .tracking(1)
          Text(vm.getFormattedDateFromDate(date: concert.setlist.date, format: "MM.dd"))
            .foregroundStyle(Color.mainBlack)
        }
        .font(.headline)
        
        Spacer()
        
        // MARK: Venue
        VStack(alignment: .leading) {
          Text("\(concert.setlist.city), \(concert.setlist.country)")
            .font(.subheadline)
            .foregroundStyle(Color.mainBlack)
          Text(concert.setlist.venue)
            .font(.footnote)
            .foregroundStyle(Color.fontGrey25)
        }
        .lineLimit(1)
        .frame(width: UIWidth * 0.5, alignment: .leading)
        .padding(.vertical, 10)
        
        Spacer()
        
        // MARK: Menu Button
        Menu {
          NavigationLink {
            SetlistView(setlistId: concert.setlist.setlistId, artistInfo: vm.artistInfo)
          } label: {
            Text("세트리스트 보기")
          }

          Button {
            vm.swiftDataManager.deleteArchivedConcertInfo(concert)
            for (index, item) in bookmarkedSetlists.enumerated() {
              if item.id == concert.id {
                bookmarkedSetlists.remove(at: index)
              }
            }
          } label: {
            Text("공연 북마크 취소")
          }

        } label: {
          Image(systemName: "ellipsis")
            .foregroundStyle(Color.mainBlack)
            .font(.title3)
            .padding()
            .background(Color.clear)
        }
        
        Spacer()
      }
      
      Divider()
        .padding(.horizontal)
        .foregroundColor(Color.lineGrey1)
    }
    
  }
  
  private var navigationLayer: some View {
    Button {
      vm.archivingViewModel.selectSegment = .bookmark
      vm.archivingViewModel.selectArtist = vm.artistInfo.name
      if selectedTab == .archiving {
        dismiss()
      } else {
        selectedTab = .archiving
      }
    } label: {
      HStack {
        Spacer()
        Group {
          Text("\(vm.artistInfo.name) 보관함에서 보기")
            .multilineTextAlignment(.trailing)
          Image(systemName: "arrow.right")
        }
      }
      .font(.subheadline)
      .foregroundColor(Color.mainBlack)
      .padding()
      .padding(.horizontal, 10)
    }
  }
  
}

#Preview {
  BookmarkedSetlistsView(vm: ArtistViewModel(), selectedTab: .constant(.archiving))
}
