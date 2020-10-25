//
//  Typo.swift
//  DndUI
//
//  Created by Gunter on 2020/10/25.
//

import BonMot

public enum Typo {
  public static func h1Font(color: UIColor) -> StringStyle {
    return StringStyle(
      .font(.boldSystemFont(ofSize: 24)),
      .color(color)
    )
  }
  public static func h2Font(color: UIColor) -> StringStyle {
    return StringStyle(
      .font(.systemFont(ofSize: 24, weight: .medium)),
      .color(color)
    )
  }
  public static func h3Font(color: UIColor) -> StringStyle {
    return StringStyle(
      .font(.systemFont(ofSize: 16, weight: .medium)),
      .color(color)
    )
  }
  public static func bodyFont(color: UIColor) -> StringStyle {
    return StringStyle(
      .font(.systemFont(ofSize: 14, weight: .medium)),
      .color(color)
    )
  }
  public static func labelFont(color: UIColor) -> StringStyle {
    return StringStyle(
      .font(.systemFont(ofSize: 12, weight: .medium)),
      .color(color)
    )
  }
  public static func buttonMediumFont(color: UIColor) -> StringStyle {
    return StringStyle(
      .font(.systemFont(ofSize: 14, weight: .medium)),
      .color(color)
    )
  }
}
