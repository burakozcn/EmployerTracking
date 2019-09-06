import RealmSwift
import Realm

class Categories: Object {
  @objc dynamic var name: String
  let employers: List<Employers>
  
  init(name: String, employers: List<Employers>) {
    self.name = name
    self.employers = employers
    super.init()
  }
  
  required init() {
    name = " "
    employers = List<Employers>()
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    name = " "
    employers = List<Employers>()
    super.init(realm: realm, schema: schema)
  }
  
  required init(value: Any, schema: RLMSchema) {
    name = " "
    employers = List<Employers>()
    super.init(value: value, schema: schema)
  }
}
