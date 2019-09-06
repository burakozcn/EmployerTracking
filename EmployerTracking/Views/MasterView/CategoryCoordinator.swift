import UIKit
import RxSwift

class CategoryCoordinator: BaseCoordinator<Void> {
  private weak var window: UIWindow?
  private var categoryVC: CategoryViewController!
  private var viewModel: CategoryListViewModel!
  private var sideBar: SideBarTableViewController!
  private var mainViewController: MainViewController!
  
  init(window: UIWindow) {
    self.window = window
    super.init()
  }
  
  override func start() -> Observable<Void> {
    categoryVC = CategoryViewController()
    sideBar = SideBarTableViewController()
    viewModel = CategoryListViewModel()
    mainViewController = MainViewController(leftViewController: sideBar, mainViewController: categoryVC)
    mainViewController.rightBarButton = categoryVC.rightBarButton
    mainViewController.leftBarButton = categoryVC.leftBarButton
    
    let navigationController = UINavigationController(rootViewController: mainViewController)
    categoryVC.viewModel = viewModel
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    window = nil
    return Observable.never()
  }
  
  func openCategory(on rootViewController: UINavigationController) -> Observable<Void> {
    let categoryAddController = CategoryAddCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: categoryAddController)
  }
  
  func openEmployer(on rootViewController: UINavigationController, category: Categories) -> Observable<Void> {
    let employerCoordinator = EmployerCoordinator(rootViewController: rootViewController, category: category)
    return coordinate(coordinator: employerCoordinator)
  }
}
