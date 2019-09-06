import RealmSwift
import Realm

class Employers: Object {
  @objc dynamic var name: String
  @objc dynamic var imageURL: String
  @objc dynamic var position: String
  @objc dynamic var education: String
  @objc dynamic var startDate: Date

  let cats = LinkingObjects(fromType: Categories.self, property: "employers")
  
  init(name: String, imageURL: String, position: String, education: String, startDate: Date) {
    self.name = name
    self.imageURL = imageURL
    self.position = position
    self.education = education
    self.startDate = startDate
    super.init()
  }
  
  required init() {
    name = " "
    imageURL = " "
    position = " "
    education = " "
    startDate = Date()
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    name = " "
    imageURL = " "
    position = " "
    education = " "
    startDate = Date()
    super.init(realm: realm, schema: schema)
  }
  
  required init(value: Any, schema: RLMSchema) {
    name = " "
    imageURL = " "
    position = " "
    education = " "
    startDate = Date()
    super.init(value: value, schema: schema)
  }

}
