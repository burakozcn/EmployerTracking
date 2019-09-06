import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfEmployer: SectionModelType {
  typealias Item = Employers
  
  var header: String
  var items: [Item]
  
  init(original: SectionOfEmployer, items: [Item]) {
    self = original
    self.items = items
  }
  
  init(header: String, items: [Item]) {
    self.header = header
    self.items = items
  }
}
