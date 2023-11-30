//
//  ShareSetlistView.swift
//  Core
//
//  Created by 예슬 on 2023/11/17.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ShareSetlistView: View {
  @ObservedObject var vm = SetlistViewModel()
  let songList: [(String, String?)]
  let artist: String
  let setlist: Setlist?
  let sessionInfo: [(String, Bool)]
  let headHeight: CGFloat
  let fontSize: CGFloat
  let aLineMax: Int
  let is2Columns: Bool

  init(songList: [(String, String?)], artist: String, setlist: Setlist?, sessionInfo: [(String, Bool)]) {
    self.songList = songList
    self.artist = artist
    self.setlist = setlist
    self.sessionInfo = sessionInfo

    let totalLine = songList.count + ((setlist?.sets?.setsSet ?? []).count-1) * 2
    headHeight = setlist?.tour?.name == nil ? 530 : 600
    aLineMax = totalLine > 50 ? 36 : 25
    is2Columns = totalLine > 36 ? true : false
    switch totalLine {
    case 0...18: fontSize = 50
    case 19...20: fontSize = 45
    case 21...36: fontSize = 30
    default: fontSize = 25
    }
  }

  var body: some View {
    VStack(spacing: -3) {
      headView
      dotLine
      shareListView
      dotLine
      bottomView
    }
    .kerning(1.1)
    .frame(width: 1080, height: 1920)
    .foregroundColor(.black)
    .background(Color.black)
  }

  private var dotLine: some View {
    Rectangle()
      .stroke(style: StrokeStyle(lineWidth: 6, dash: [12]))
      .frame(height: 4)
      .foregroundStyle(Color.black)
      .alignmentGuide(.top) { _ in 1 }
      .padding(.horizontal, 40)
  }

  private var whiteBox: some View {
    RoundedRectangle(cornerRadius: 40)
      .foregroundStyle(.white)
    
  }

  private var dividerLine: some View {
    Rectangle()
      .foregroundStyle(.black)
      .frame(height: 3)
      .padding(.vertical, -10)
  }

  private var headView: some View {
    ZStack {
      whiteBox
      VStack(alignment: .leading) {
        Text(artist)
          .font(.system(size: 50))
        dividerLine
        if let tour = setlist?.tour?.name {
          Text(tour)
            .font(.system(size: 50))
          dividerLine
        }
        let venue = "\(setlist?.venue?.name ?? ""), \(setlist?.venue?.city?.name ?? ""), \(setlist?.venue?.city?.country?.name ?? "")"
        Text(venue)
          .font(.system(size: 50))
        dividerLine
        Text(vm.getFormattedDateFromString(date: setlist?.eventDate ?? "", format: "MMM dd, yyyy") ?? "")
          .font(.system(size: 50))
          .padding(.bottom)
      }
      .padding([.horizontal, .bottom], 28)
      .frame(maxWidth: .infinity, maxHeight: headHeight, alignment: .bottomLeading)
    }
    .frame(width: 1080, height: headHeight)
  }

  private var bottomView: some View {
    ZStack {
      whiteBox
      Image("seta", bundle: Bundle(identifier: "com.creative8.seta.UI"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 28)
    }
    .frame(width: 1080, height: 162)
  }

  private var shareListView: some View {
    ZStack {
      whiteBox
      Group {
        if !is2Columns {
          VStack {
            ForEach(0..<sessionInfo.count, id: \.self) { index in
              if sessionInfo[index].0 == "" && index == 0 { }
              else if sessionInfo[index].1 == true {
                Text("\(sessionInfo[index].0)")
                  .fontWeight(.semibold)
                  .underline()
                  .font(.system(size: fontSize))
                  .lineLimit(1)
              } else {
                Text(sessionInfo[index].0)
                  .font(.system(size: fontSize))
                  .lineLimit(1)
              }
            }
          }
        } else {
          HStack(spacing: 0) {
            Group {
              VStack(alignment: .leading) {
                ForEach(0..<aLineMax, id: \.self) { index in
                  if sessionInfo[index].0 == "" && index == 0 { }
                  else if sessionInfo[index].1 == true {
                    Text("\(sessionInfo[index].0)")
                      .fontWeight(.semibold)
                      .underline()
                      .font(.system(size: fontSize))
                      .lineLimit(1)
                  } else {
                    Text(sessionInfo[index].0)
                      .font(.system(size: fontSize))
                      .lineLimit(1)
                  }
                }

              }

              VStack(alignment: .leading) {
                ForEach(aLineMax..<sessionInfo.count, id: \.self) { index in
                  if sessionInfo[index].0 == "" && index == aLineMax { }
                  else if sessionInfo[index].1 == true {
                    Text("\(sessionInfo[index].0)")
                      .fontWeight(.semibold)
                      .underline()
                      .font(.system(size: fontSize))
                      .lineLimit(1)
                  } else {
                    Text(sessionInfo[index].0)
                      .font(.system(size: fontSize))
                      .lineLimit(1)
                  }
                }
              }
            }
            .frame(width: 510, alignment: .leading)
          }
          .frame(width: 1080)
        }
      }
    }
  }
}

extension ShareSetlistView {
  func setlistImage() -> UIImage {
    let setlistImage = body.createSetlistImage(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
    return setlistImage
  }
}

extension View {
  func createSetlistImage(origin: CGPoint, size: CGSize) -> UIImage {
    let origin = CGPoint(x: 0, y: 0)
    let size = CGSize(width: 1080, height: 1920)
    
    let window = UIWindow(frame: CGRect(origin: origin, size: size))
    let hosting = UIHostingController(rootView: self)
    hosting.view.frame = window.frame
    window.addSubview(hosting.view)
    window.makeKeyAndVisible()
    return hosting.view.setlistImage
  }
}

extension UIView {
  var setlistImage: UIImage {
    let rect = self.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    self.layer.render(in: context)
    let shareImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    return shareImage
  }
}

public extension View {
  func shareSetlistToImage(_ songList: [(String, String?)], _ artist: String, _ setlist: Setlist?) -> UIImage {
    print("songList.count: \(songList.count)")
    print("songList: \(songList)")
    var sessionInfo: [(String, Bool)] = []
    var count = 0
    if let setsSet = setlist?.sets?.setsSet {
      for session in setsSet {
        let sessionName = session.name ?? (session.encore != nil ? "Encore" : "")
        sessionInfo.append(("", false))
        sessionInfo.append((sessionName, true))
        if let song = session.song {
          
          for _ in song {
            if count < songList.count {
              sessionInfo.append((songList[count].0, false))
              print(songList[count].0)
              count += 1
            }
          }
          print(setsSet.count)
          print("sessionInfo.count: \(sessionInfo.count)")
          print("sessionInfo: \(sessionInfo)")
        }
      }
    }
    let captureView = ShareSetlistView(songList: songList,
                                       artist: artist,
                                       setlist: setlist,
                                       sessionInfo: sessionInfo)
    return captureView.setlistImage()
  }
}
