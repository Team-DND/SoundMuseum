//
//  FirestoreService.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import RxFirebase
import FirebaseFirestore
import RxSwift

protocol FirestoreSerivceProtocol {
  func fetchSound() -> Observable<[Sound]>
}

final class FirestoreService: FirestoreSerivceProtocol {
  private let db = Firestore.firestore()

  func fetchSound() -> Observable<[Sound]> {
    return db.collection("sounds")
      .rx
      .getDocuments()
      .map { snapshot -> [Sound] in
        let dictionaries = snapshot.documents.compactMap { $0.data() }
        let sounds = dictionaries.compactMap { Sound(dic: $0) }
        return sounds
      }
  }
}
