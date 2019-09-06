import UIKit

class SideBarTableViewModel {
  var coordinator: SideBarTableCoordinator!
  weak var navVC: UINavigationController?
  
  func openSideDetail(_ name: String) {
    navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    coordinator = SideBarTableCoordinator(rootViewController: navVC!)
    coordinator.openDetail(name: name)
  }
}
