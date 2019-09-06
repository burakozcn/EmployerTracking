import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfCategory: SectionModelType {
  typealias Item = Categories
  
  var header: String
  var items: [Item]
  
  init(original: SectionOfCategory, items: [Item]) {
    self = original
    self.items = items
  }
  
  init(header: String, items: [Item]) {
    self.header = header
    self.items = items
  }
}
