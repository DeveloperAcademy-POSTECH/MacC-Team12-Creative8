//
//  ServiceExplainView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/16.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct ServiceExplainView: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
  var body: some View {
    ZStack {
      Color(Color.backgroundGrey)
      ScrollView {
        VStack {
          SectionBackgroundView()
            .overlay {
              VStack(alignment: .leading) {
                TermsTitleView(title: "서비스 이용 약관")
                  .padding(.top, 30)
                
                // 약관 상세 내용
                TermsView(terms: viewModel.termsOfService, bulletPoint: "")
                  .padding(.bottom, 51)
              }
              .padding(.horizontal, 26)
            }
            .padding(EdgeInsets(top: 120, leading: 20, bottom: 40, trailing: 20))
        }
      }
    }
    .ignoresSafeArea()
  }
}

struct TermsOfSetlistfm: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
  var body: some View {
    ZStack {
      Color(Color.backgroundGrey)
      ScrollView {
        VStack {
          SectionBackgroundView()
            .overlay {
              VStack(alignment: .leading) {
                TermsTitleView(title: "Setlist.fm API 약관")
                  .padding(.top, 30)
                
                // 약관 상세 내용
                TermsView(terms: viewModel.termsOfSelistfmAPI, bulletPoint: "•")
                
                // Setlist.fm 약관 이동 버튼
                SetlistfmLinkButton(
                  setlistfmURL: "https://www.setlist.fm/help/terms",
                  linkLabel: "Setlist.fm 약관 자세히 보기")
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 50, trailing: 0))
              }
              .padding(.horizontal, 26)
            }
            .padding(EdgeInsets(top: 120, leading: 20, bottom: 40, trailing: 20))
        }
      }
    }
    .ignoresSafeArea()
  }
}

struct TermsTitleView: View {
  
  var title: LocalizedStringResource
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.system(.callout, weight: .bold))
        .foregroundStyle(Color.mainBlack)
      Divider()
        .foregroundStyle(Color.lineGrey1)
    }
  }
}

struct TermsView: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
  var terms: [LocalizedStringResource]
  var bulletPoint: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(terms[0])
        .font(.footnote)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.top, 16)
      ForEach(1..<terms.count, id: \.self) { index in
        HStack(alignment: .top) {
          Text(bulletPoint == "•" ? bulletPoint : "\(index).")
          Text(terms[index])
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom)
        }
        .font(.footnote)
        .lineSpacing(4)
      }
    }
    .foregroundStyle(Color.fontGrey2)
  }
}

struct SectionBackgroundView: View {
  
//  var height: CGFloat
  
  var body: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.settingTextBoxWhite)
//      .frame(height: height)
  }
}

#Preview {
  TermsOfSetlistfm()
}

/// UIViewReperesentable을 사용해서 UIKit을 매핑해야함.
/// UILabel()의 linebreakmode 설정을 하면 단어 단위로 다음 줄로 넘어가게 할 수 있음
/// 만약 Hstack 내부에서 저 장문의 글만 처리하려고 하면 Geometry Reader를 써서 width를 넘겨줘야 할듯함
/// 제일 쉬운 방법 : 이미지 다크-라이트모드로 걍 넣으셈

// struct SUILabel: UIViewRepresentable {
//
//    private(set) var preferredMaxLayoutWidth: CGFloat = 0
//    func makeUIView(context: UIViewRepresentableContext<SUILabel>) -> UILabel {
//        let label = UILabel()
//        label.text = """
//        HIHI
//        """
//        label.numberOfLines = 0
//        label.textColor = UIColor.white
//        return label
//    }
//
//    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<SUILabel>) { }
// }
