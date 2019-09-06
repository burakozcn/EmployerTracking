import UIKit
import RxSwift

class EmployerCoordinator: BaseCoordinator<Void> {
  private weak var rootViewController: UINavigationController?
  private var viewModel: EmployerListViewModel!
  private var viewController: EmployerViewController!
  private let category: Categories
  private var sideBar: SideBarTableViewController!
  private var mainViewController: MainViewController!
  
  init(rootViewController: UINavigationController, category: Categories) {
    self.category = category
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = EmployerViewController(category: category)
    viewModel = EmployerListViewModel(category: category)
    viewController.viewModel = viewModel
    sideBar = SideBarTableViewController()
    mainViewController = MainViewController(leftViewController: sideBar, mainViewController: viewController)
    mainViewController.rightBarButton = viewController.rightBarButton
    mainViewController.leftBarButton = viewController.leftBarButton
    
    rootViewController?.pushViewController(mainViewController, animated: true)
    
    rootViewController = nil
    return Observable.never()
  }
  
  @discardableResult
  func openEmployer(on rootViewController: UINavigationController) -> Observable<Void> {
    let employerAddCoordinator = EmployerAddCoordinator(rootViewController: rootViewController, category: category)
    return coordinate(coordinator: employerAddCoordinator)
  }
  
  @discardableResult
  func openDetail(on rootViewController: UINavigationController, employers: Employers) -> Observable<Void> {
    let detailViewCoordinator = DetailCoordinator(rootViewController: rootViewController, employers: employers)
    return coordinate(coordinator: detailViewCoordinator)
  }
  
  @discardableResult
  func openCategory(on window: UIWindow?) -> Observable<Void> {
    let categoryCoordinator = CategoryCoordinator(window: window!)
    return coordinate(coordinator: categoryCoordinator)
  }
}
