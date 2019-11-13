import RxSwift
import RxCocoa
import RealmSwift
import UIKit
import Photos

class EmployerAddViewModel {
  var model: Employers!
  var coordinator: EmployerAddCoordinator!
  var viewController: EmployerAddViewController!
  var realm: Realm!
  let category: Categories
  
  init(category: Categories) {
    self.category = category
  }
  
  func saveEmployer(name: String?, position: String?, education: String?, startDate: String?, imageView: UIImageView?, category: Categories?) {
    model = Employers()
    
    if let name = name, let category = category {
      realm = try! Realm()
      model.name = name
      let cat = realm.objects(Categories.self).filter(NSPredicate(format: "name = %@", category.name)).first!
      
      if let position = position {
        model.position = position
      }
      
      if let education = education {
        model.education = education
      }
      
      if let startDate = startDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: startDate)
        if let date = date {
          model.startDate = date
        } else {
          print("Date couldn't be found")
        }
      }
      
      if let image = imageView?.image {
        let fileManager = FileManager.default
        let storeURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if storeURL.count > 0 {
          let writePath = storeURL[0].appendingPathComponent("\(name).png")
          try! UIImage.pngData(image)()?.write(to: writePath)
          model.imageURL = writePath.path
        }
      }
      
      try! realm.write {
        realm.add(model)
        cat.employers.append(model)
      }
    } else {
      print("We couldn't find name")
    }
  }
  
  func showAlert() {
    viewController = EmployerAddViewController(category: category)
    viewController.showAlert()
  }
  
  func backToEmployer() {
    let rootVC = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = EmployerAddCoordinator(rootViewController: rootVC, category: category)
    coordinator.openEmployer()
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
      print("An unknown problem has been occured.")
    }
  }
}
