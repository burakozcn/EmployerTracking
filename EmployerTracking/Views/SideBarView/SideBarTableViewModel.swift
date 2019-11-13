import UIKit

class SideBarTableViewModel {
  var coordinator: SideBarTableCoordinator!
  weak var navVC: UINavigationController?
  
  func openSideDetail(_ name: String) {
    navVC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
    coordinator = SideBarTableCoordinator(rootViewController: navVC!)
    coordinator.openDetail(name: name)
  }
}
