import UIKit
import RxSwift
import RxCocoa

class CategoryAddViewController: UIViewController {
  let disposeBag = DisposeBag()
  var viewModel: CategoryAddViewModel!
  
  let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = .white
    label.text = NSLocalizedString("catName", comment: "Category Name:     ")
    return label
  }()
  
  let textField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.text? = ""
    return textField
  }()
  
  let button: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString("submit", comment: "Submit"), for: .normal)
    return button
  }()
  
  let leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("catback", comment: "< Category"), style: .plain, target: nil, action: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = leftBarButtonItem
    setupUI()
    
    viewModel = CategoryAddViewModel()
    
    textField.rx.text.orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
      .bind(to: button.rx.isEnabled)
      .disposed(by: disposeBag)
    
    button.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.saveCategory(self.textField.text)
        self.viewModel.showAlert()
      }).disposed(by: disposeBag)
    
    leftBarButtonItem.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.backToCategory()
      }).disposed(by: disposeBag)
  }
  
  func setupUI() {
    let guide = view.readableContentGuide
    
    view.addSubview(label)
    view.addSubview(textField)
    view.addSubview(button)
    
    label.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    textField.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
    textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    
    button.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.widthAnchor.constraint(equalToConstant: 150).isActive = true
    button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40).isActive = true
  }
  
  func showAlert() {
    viewModel = CategoryAddViewModel()
    let alert = UIAlertController(title: NSLocalizedString("success", comment: "Success"), message: NSLocalizedString("savesuccess", comment: "Saved successfully."), preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
      self.viewModel.backToCategory()
    }))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
