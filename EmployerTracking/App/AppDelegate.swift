import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  static var interval1 = Date.timeIntervalSinceReferenceDate
  private var coordinator: AppCoordinator!
  private let disposeBag = DisposeBag()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
        
    coordinator = AppCoordinator(window: window!)
    coordinator.start()
      .subscribe()
      .disposed(by: disposeBag)
    
    return true
  }

}

