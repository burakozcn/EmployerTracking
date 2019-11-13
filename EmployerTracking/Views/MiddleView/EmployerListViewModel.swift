import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Realm
import RealmSwift

class EmployerListViewModel {
  private let identifier = "CollectionCell"
  var coordinator: EmployerCoordinator!
  var realm: Realm!
  var category: Categories
  weak var window: UIWindow?
  weak var navVC: UINavigationController?
  
  init(category: Categories) {
    self.category = category
  }
  
  var sections: [SectionOfEmployer] {
    realm = try! Realm()
    let cat = realm.objects(Categories.self).filter(NSPredicate(format: "name = %@", category.name)).first!
    let employers = cat.employers
    var sectEmp = [SectionOfEmployer]()
    
    for i in 0 ..< employers.count {
      let employer = SectionOfEmployer(header: "First Section", items: [Employers(name: employers[i].name, imageURL: employers[i].imageURL, position: employers[i].position, education: employers[i].education, startDate: employers[i].startDate)])
      sectEmp.append(employer)
    }
    return sectEmp
  }
  
  func source(_ collectionView: UICollectionView) -> RxCollectionViewSectionedReloadDataSource<SectionOfEmployer> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfEmployer> (configureCell: {
      dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! CustomCollectionViewCell
      cell.nameLabel.text = item.name
      cell.positionLabel.text = item.position
      cell.educationLabel.text = item.education
      cell.dateLabel.text = item.startDate.toString(dateFormat: "dd-MM-yyyy")
      cell.employers = item as Employers
      
      let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let path = storeURL.appendingPathComponent("\(item.name).png").path
      cell.imageView.image = UIImage(contentsOfFile: path)
      
      return cell
    })
    return dataSource
  }
  
  func addEmployer() {
    window = UIApplication.shared.windows.first
    navVC = window?.rootViewController as? UINavigationController
    coordinator = EmployerCoordinator(rootViewController: navVC!, category: category)
    coordinator.openEmployer(on: navVC!)
  }
  
  func openDetail(_ index: Int, category: Categories, employers: Employers) {
    window = UIApplication.shared.windows.first
    navVC = window?.rootViewController as? UINavigationController
    coordinator = EmployerCoordinator(rootViewController: navVC!, category: category)
    coordinator.openDetail(on: navVC!, employers: employers)
  }
  
  func backToCategory() {
    window = UIApplication.shared.windows.first
    navVC = window?.rootViewController as? UINavigationController
    coordinator = EmployerCoordinator(rootViewController: navVC!, category: category)
    coordinator.openCategory(on: window)
  }
}
