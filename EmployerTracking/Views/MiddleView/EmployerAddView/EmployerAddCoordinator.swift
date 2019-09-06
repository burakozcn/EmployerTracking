import RxSwift
import UIKit

class EmployerAddCoordinator: BaseCoordinator<Void> {
  private weak var rootViewController: UINavigationController?
  private var viewController: EmployerAddViewController!
  private var viewModel: EmployerAddViewModel!
  private var category: Categories
  
  init(rootViewController: UINavigationController, category: Categories) {
    self.rootViewController = rootViewController
    self.category = category
  }
  
  override func start() -> Observable<Void> {
    viewController = EmployerAddViewController(category: category)
    
    viewModel = EmployerAddViewModel(category: category)
    viewController.viewModel = viewModel
    
    rootViewController?.pushViewController(viewController, animated: true)
    
    rootViewController = nil
    return Observable.never()
  }
  
  @discardableResult
  func openEmployer() -> Observable<Void> {
    let rootVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    let employerCoordinator = EmployerCoordinator(rootViewController: rootVC, category: category)
    return coordinate(coordinator: employerCoordinator)
  }
}
