import RxSwift
import UIKit

class AppCoordinator: BaseCoordinator<Void> {
  private weak var window: UIWindow?
  
  init(window: UIWindow) {
    self.window = window
  }
  
  override func start() -> Observable<Void> {
    let categoryCoordinator = CategoryCoordinator(window: window!)
    return coordinate(coordinator: categoryCoordinator)
  }
}
