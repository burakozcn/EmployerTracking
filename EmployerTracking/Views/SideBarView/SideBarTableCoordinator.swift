import RxSwift
import UIKit

class SideBarTableCoordinator: BaseCoordinator<Void> {
  private weak var rootViewController: UINavigationController?
  private var viewController: SideBarTableViewController!
  private var viewModel: SideBarTableViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = SideBarTableViewController()
    
    viewModel = SideBarTableViewModel()
    viewController.viewModel = viewModel
    
    rootViewController?.pushViewController(viewController, animated: true)
    
    rootViewController = nil
    return Observable.never()
  }
  
  func openDetail(name: String) {
      let story = Story(rawValue: name)
      let vc = SideBarDetailViewController(story: story!)
    rootViewController?.pushViewController(vc, animated: true)
  }
}
