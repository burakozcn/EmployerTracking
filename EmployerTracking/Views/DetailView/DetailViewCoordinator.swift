import UIKit
import RxSwift

class DetailCoordinator: BaseCoordinator<Void> {
  private weak var rootViewController: UINavigationController?
  private let employers: Employers
  private var viewController: DetailViewController!
  private var viewModel: DetailViewModel!
  
  init(rootViewController: UINavigationController, employers: Employers) {
    self.rootViewController = rootViewController
    self.employers = employers
  }
  
  override func start() -> Observable<Void> {
    viewController = DetailViewController(employer: employers)
    viewModel = DetailViewModel(employers: employers)
    viewController.viewModel = viewModel
    
    rootViewController?.pushViewController(viewController, animated: true)
    
    rootViewController = nil
    return Observable.never()
  }
  
  @discardableResult
  func backToCollection(category: Categories) -> Observable<Void> {
    let rootVC = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    let employerCoordinator = EmployerCoordinator(rootViewController: rootVC, category: category)
    return coordinate(coordinator: employerCoordinator)
  }
}
