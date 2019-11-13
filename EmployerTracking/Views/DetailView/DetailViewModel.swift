import UIKit
import RxSwift
import Realm
import RealmSwift
import Photos

class DetailViewModel {
  private var employers: Employers
  private var viewController: DetailViewController!
  private var realm: Realm!
  private var coordinator: DetailCoordinator!
  weak var navVC: UINavigationController?
  
  init(employers: Employers) {
    self.employers = employers
  }
  
  func edit(_ name: String, position: String?, education: String?, startDate: String?, image: UIImage?) {
    realm = try! Realm()
    
    let employer = realm.objects(Employers.self).filter(NSPredicate(format: "name = %@", employers.name)).first!
    
    try! realm.write {
      employer.name = name
      employer.position = position ?? ""
      employer.education = education ?? ""
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
      let date = dateFormatter.date(from: startDate ?? "01/01/2019")
      employer.startDate = date ?? Date()
      
      if let image = image {
        let fileManager = FileManager.default
        let storeURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if storeURL.count > 0 {
          let writePath = storeURL[0].appendingPathComponent("\(name).png")
          try! UIImage.pngData(image)()?.write(to: writePath)
          employer.imageURL = writePath.path
        }
      }
    }
    employers = employer
  }
  
  func showAlert() {
    viewController = DetailViewController(employer: employers)
    viewController.showAlert()
  }
  
  func delete() {
    realm = try! Realm()
    viewController = DetailViewController(employer: employers)
    
    let employer = realm.objects(Employers.self).filter(NSPredicate(format: "name = %@", employers.name)).first!
    let category = employer.cats.first!
    try! realm.write {
      realm.delete(employer)
    }
    viewController.deleteAlert(category: category)
  }
  
  func backToEmployer() {
    realm = try! Realm()
    
    let employer = realm.objects(Employers.self).filter(NSPredicate(format: "name = %@", employers.name)).first!
    let category = employer.cats.first!
    backtoCollection(category: category)
  }
  
  func backtoCollection(category: Categories) {
    navVC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
    coordinator = DetailCoordinator(rootViewController: navVC!, employers: employers)
    coordinator.backToCollection(category: category)
  }
  
  func openGallery(viewController: UIViewController) {
    checkPermission()
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      viewController.present(imagePicker, animated: true, completion: nil)
    }
    else
    {
      let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      viewController.present(alert, animated: true, completion: nil)
    }
  }
  
  func checkPermission() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatus {
    case .authorized:
      print("Access is granted by user")
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization({
        (newStatus) in
        print("status is \(newStatus)")
        if newStatus ==  PHAuthorizationStatus.authorized {
          print("success")
        }
      })
      print("It is not determined until now")
    case .restricted:
      print("User do not have access to photo album.")
    case .denied:
      print("User has denied the permission.")
    @unknown default:
      print("Unknown error has occured.")
    }
  }
}

