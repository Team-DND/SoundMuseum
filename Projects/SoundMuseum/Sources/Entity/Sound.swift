//
//  Sound.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import Foundation

struct Sound: Hashable {
  let name: String
  let soundURL: String
  let imgURL: String

  init(dic: [String: Any]) {
    self.name = dic["name"] as? String ?? ""
    self.soundURL = dic["soundURL"] as? String ?? ""
    self.imgURL = dic["imgURL"] as? String ?? ""
  }

  init(name: String, soundURL: String, imgURL: String) {
    self.name = name
    self.soundURL = soundURL
    self.imgURL = imgURL
  }
}
