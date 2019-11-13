import RxSwift
import UIKit

class CategoryAddCoordinator: BaseCoordinator<Void> {
  private weak var rootViewController: UINavigationController?
  private var viewController: CategoryAddViewController!
  private var viewModel: CategoryAddViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = CategoryAddViewController()
    
    viewModel = CategoryAddViewModel()
    viewController.viewModel = viewModel
    
    rootViewController?.pushViewController(viewController, animated: true)
    
    rootViewController = nil
    return Observable.never()
  }
  
  @discardableResult
  func openCategory() -> Observable<Void> {
    let window = UIApplication.shared.windows.first
    let categoryCoordinator = CategoryCoordinator(window: window!)
    return coordinate(coordinator: categoryCoordinator)
  }
}
