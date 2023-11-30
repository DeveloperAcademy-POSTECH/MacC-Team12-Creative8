//
//  SettingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/08.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

public struct SettingView: View {
  
  public init() {}
  
  public var body: some View {
    ZStack {
      Color.backgroundWhite
      ScrollView {
        VStack(alignment: .leading) {
          
          // 세트리스트 추가 및 수정하기
          VStack(alignment: .leading) {
            SectionTitleView(
              sectionTitle: "세트리스트 추가 및 수정하기",
              sectionTopDescription: "Setlist.fm에서 다녀온 공연의 세트리스트를", sectionBottomDescription: "추가 및 수정하세요")
            SetlistfmLinkButton(
              setlistfmURL: "https://www.setlist.fm",
              linkLabel: "Setlist.fm 바로가기")
            .padding(.bottom, 20)
          }

          // 서비스 이용 관련
          VStack(alignment: .leading) {
            Divider()
              .foregroundStyle(Color.lineGrey1)
            SectionTitleView(
              sectionTitle: "서비스 이용 관련",
              sectionTopDescription: "음악으로 연결되는 순간,", sectionBottomDescription: "Seta의 서비스 약관을 확인해보세요")
            
            // FAQ
            Link(destination: URL(string: "https://inquisitive-digit-cfe.notion.site/FAQ-10f7d0c94c104015b5719ab2a26f2cf2?pvs=4")!, label: {
              LinkLabelView(linkLabel: "FAQ")
            })
            Divider()
              .foregroundStyle(Color.lineGrey1)
            
            // 문의하기
            AskView()
            Divider()
              .foregroundStyle(Color.lineGrey1)
            
            // 이용 약관
            Link(destination: URL(string: "https://inquisitive-digit-cfe.notion.site/3b69b21a1afc4306bcccde7019d6379d?pvs=4")!, label: {
              LinkLabelView(linkLabel: "이용 약관")
            })
            Divider()
              .foregroundStyle(Color.lineGrey1)

            // 개인정보 처리방침
            Link(destination: URL(string: "https://inquisitive-digit-cfe.notion.site/1d16107bb0f34e629bcbd30a25ceb5d0?pvs=4")!, label: {
              LinkLabelView(linkLabel: "개인정보 처리방침")
            })
          }
        }
        .padding(.horizontal, 25)
        .padding(.vertical)
      }
      .scrollIndicators(.hidden)
    }
    .navigationTitle("더보기")
  }
}

struct SectionTitleView: View {
  
  var sectionTitle: LocalizedStringResource
  var sectionTopDescription: LocalizedStringResource
  var sectionBottomDescription: LocalizedStringResource
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(sectionTitle)
        .font(.headline)
        .foregroundStyle(Color.mainBlack)
        .padding(.vertical)
      VStack(alignment: .leading, spacing: 0) {
        Text(sectionTopDescription)
        Text(sectionBottomDescription)
      }
        .font(.footnote)
        .foregroundStyle(Color.fontGrey2)
        .padding(.bottom, 30)
    }
  }
}

struct SetlistfmLinkButton: View {
  
  var setlistfmURL: String
  var linkLabel: LocalizedStringResource
  
  var body: some View {
    Link(destination: URL(string: setlistfmURL)!, label: {
      HStack {
        Spacer()
        Text(linkLabel)
          .font(.system(.callout, weight: .semibold))
        Spacer()
      }
      .frame(height: 54)
      .background(Color.mainGrey1)
      .foregroundStyle(Color.mainBlack)
      .clipShape(RoundedRectangle(cornerRadius: 14))
      .padding(.horizontal, 7)
    })
  }
}

struct LinkLabelView: View {
  
  var linkLabel: LocalizedStringResource
  
  var body: some View {
    HStack {
      Text(linkLabel)
        .font(.subheadline)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
      Spacer()
      Image(systemName: "chevron.right")
        .resizable()
        .frame(width: 10, height: 15)
        .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 15))
    }
    .foregroundStyle(Color.mainBlack)
  }
}

#Preview {
  NavigationStack {
    SettingView()
  }
}
