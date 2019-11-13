import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Realm
import RealmSwift

class CategoryListViewModel {
  private let cellIdentifier = "TableCell"
  var realm: Realm!
  var coordinator: CategoryCoordinator!
  var model: Categories!
  weak var window: UIWindow?
  weak var navVC: UINavigationController?
  
  var sections: [SectionOfCategory] {
    realm = try! Realm()
    let categories = realm.objects(Categories.self)
    
    var sectCat = [SectionOfCategory]()
    
    for i in 0 ..< categories.count {
      let category = SectionOfCategory(header: "First Section", items: [Categories(name: categories[i].name, employers: categories[i].employers)])
      sectCat.append(category)
    }
    return sectCat
  }
  
  func source(_ tableView: UITableView) -> RxTableViewSectionedReloadDataSource<SectionOfCategory> {
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCategory> (configureCell: {
      dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell
      cell.nameLabel.text = item.name
      cell.countLabel.text = String(item.employers.count)
      cell.category = item
      if (item.employers.count > 0) {
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
      } else {
        cell.accessoryType = UITableViewCell.AccessoryType.none
      }
      return cell
    }, canEditRowAtIndexPath: { _, _ in
      return true
    })
    return dataSource
  }
  
  func addCat() {
    window = UIApplication.shared.windows.first
    navVC = window?.rootViewController as? UINavigationController
    coordinator = CategoryCoordinator(window: window!)
    coordinator.openCategory(on: navVC!)
  }
  
  func delete(command: TableViewEditing) -> CategoryListViewModel {
    realm = try! Realm()
    model = Categories()
      switch command {
      case .DeleteItem(let indexPath):
        var sections = self.sections
        var items = sections[indexPath.section].items
        let name = items[indexPath.row].name
        items.remove(at: indexPath.row)
        sections[indexPath.section] = SectionOfCategory(original: sections[indexPath.section], items: items)
        let object = realm.objects(Categories.self).filter(NSPredicate(format: "name = %@", name))
        let emp = object.first!.employers
        try! realm.write {
          realm.delete(emp)
          realm.delete(object)
        }
        sections = self.sections
      }
    return CategoryListViewModel()
  }
  
  func openDetail(_ index: Int, category: Categories) {
    window = UIApplication.shared.windows.first
    navVC = window?.rootViewController as? UINavigationController
    coordinator = CategoryCoordinator(window: window!)
    coordinator.openEmployer(on: navVC!, category: category)
  }
}
