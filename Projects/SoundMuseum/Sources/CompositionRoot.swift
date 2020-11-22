//
//  CompositionRoot.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import Swinject

struct AppDependency {
  let rootViewController: UIViewController
}

enum CompositionRoot {
  fileprivate static var container: Container =  Container(defaultObjectScope: .container)

  static func resolve() -> AppDependency {
    let resolver = container.synchronize()

    container.register(FirestoreSerivceProtocol.self) { _ in
      return FirestoreService()
    }

    let mainReactorFactory = MainViewReactor.Factory.init(
      dependency: .init(firestoreService: resolver.resolve())
    )
    let mainViewControllerFactory = MainViewController.Factory.init(
      dependency: .init()
    )
    let mainReactor = mainReactorFactory.create(payload: .init())
    let mainViewController = mainViewControllerFactory.create(payload: .init(reactor: mainReactor))

    return AppDependency(rootViewController: mainViewController)
  }
}

extension Resolver {
  func resolve<Service>() -> Service! {
    return self.resolve(Service.self)
  }
}
