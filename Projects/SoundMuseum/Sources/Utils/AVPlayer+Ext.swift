//
//  AVPlayer+Ext.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/25.
//

import AVKit

extension AVPlayer {
  var isPlaying: Bool {
    return ((rate != 0) && (error == nil))
  }
}
