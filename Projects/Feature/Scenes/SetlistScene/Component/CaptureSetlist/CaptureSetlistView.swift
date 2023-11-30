//
//  CaptureSetlistView.swift
//  Core
//
//  Created by A_Mcflurry on 10/16/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

public struct CaptureSetlistView: View {
  let songList: [(String, String?)]
  let showingSongCount: Int
  let showingSongLastCount: Int
  let index: Int
  public var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()
      Text("\(index)")
        .font(.system(size: 115))
        .foregroundStyle(Color.gray)
        .opacity(0.3)

        VStack(alignment: .leading) {
//          HStack {
//            Text("Seta")
//              .font(.system(size: 34))
//              .opacity(0.3)
//              .padding(.horizontal, 30)
//            Spacer()
//            logo
//              .opacity(0.3)
//              .padding(.trailing, 24)
//          }
          Image("serviceForConcertgoers", bundle: setaBundle)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIWidth * 0.87)
            .padding(.horizontal)
            .padding(.bottom)
          
          Rectangle()
            .foregroundStyle(.black)
            .frame(height: 1)
          ForEach(showingSongCount..<showingSongLastCount, id: \.self) { index in
              VStack(alignment: .leading) {
                Text("\(songList[index].0)")
                Text("\(songList[index].1 ?? "")")
              }
              .padding(.horizontal, 30)
              .font(.system(size: 17))
            .foregroundStyle(.black)
            Rectangle()
              .foregroundStyle(.black)
              .frame(height: 1)
          }
          Image("screenshotforOCR", bundle: setaBundle)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIWidth * 0.68)
            .padding(.horizontal)
            .padding(.top)
        }
        .padding(.top, 30)

    }
  }
  public var logo: some View {
       HStack(spacing: 0) {
         Rectangle()
           .frame(width: 19, height: 20)
           .cornerRadius(50, corners: .bottomRight)
           .cornerRadius(50, corners: .bottomLeft)
         Rectangle()
           .frame(width: 18, height: 20)
           .cornerRadius(50, corners: .topRight)
           .cornerRadius(50, corners: .topLeft)
       }
       .foregroundColor(Color.black)
     }
}

extension CaptureSetlistView {
  func screenShot() {
    let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
    UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
  }
}

extension View {
  func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
    let window = UIWindow(frame: CGRect(origin: origin, size: size))
    let hosting = UIHostingController(rootView: self)
    hosting.view.frame = window.frame
    window.addSubview(hosting.view)
    window.makeKeyAndVisible()
    return hosting.view.screenShot
  }
}

extension UIView {
    var screenShot: UIImage {
      let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return capturedImage
    }
}

public extension View {
  func takeSetlistToImage(_ songList: [(String, String?)]) {
    let songCount = songList.count
    let pagesongs = songCount / 10
    let remainsongs = songCount % 10
    let pictureCount = pagesongs + (remainsongs == 0 ? 0 : 1)
    for forI in 0..<pictureCount {
      let captureView = CaptureSetlistView(songList: songList,
                                           showingSongCount: 10 * forI,
                                           showingSongLastCount: forI == pictureCount-1 && remainsongs != 0 ?
                                           (10 * forI + remainsongs) : (10 * (forI + 1)),
                                           index: forI+1)
      captureView.screenShot()
    }
  }
}

extension View {
   func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
     clipShape( RoundedCorner(radius: radius, corners: corners) )
   }
 }
struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
