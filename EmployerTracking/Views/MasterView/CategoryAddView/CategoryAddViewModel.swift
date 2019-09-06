import RxSwift
import RxCocoa
import RealmSwift

class CategoryAddViewModel {
  
  var saveCat = PublishSubject<Void>()
  var vc: CategoryAddViewController!
  var coordinator: CategoryAddCoordinator!
  var realm: Realm!
  var model: Categories!
  
  func saveCategory(_ name: String?) {
    model = Categories()
    
    if let name = name {
      realm = try! Realm()        
      model.name = name
      
      try! realm.write {
        realm.add(model)
      }
    }
  }

  func showAlert() {
    vc = CategoryAddViewController()
    vc.showAlert()
  }
  
  func backToCategory() {
    coordinator = CategoryAddCoordinator(rootViewController: UIApplication.shared.keyWindow?.rootViewController as! UINavigationController)
    coordinator.openCategory()
  }
}
