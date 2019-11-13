import UIKit
import RxSwift

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  let employer: Employers
  var viewModel: DetailViewModel!
  private let disposeBag = DisposeBag()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  func label(text: String) -> UILabel {
    let label: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.backgroundColor = .white
      label.textAlignment = .center
      label.font = UIFont.boldSystemFont(ofSize: 18)
      label.text = text
      return label
    }()
    return label
  }
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.isEnabled = false
    return textField
  }()
  
  let positionTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.isEnabled = false
    return textField
  }()
  
  let educationTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.isEnabled = false
    return textField
  }()
  
  let startDateTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.isEnabled = false
    return textField
  }()
  
  let editButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .green
    let width = UIScreen.main.bounds.width * 0.24
    let height = UIScreen.main.bounds.height * 0.12
    button.frame = CGRect(x: 0, y: 0, width: width, height: height)
    button.layer.cornerRadius = 0.4 * button.bounds.size.width
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 0.9
    button.clipsToBounds = true
    button.setTitle(NSLocalizedString("edit", comment: "Edit"), for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.textColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let deleteButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .red
    let width = UIScreen.main.bounds.width * 0.24
    let height = UIScreen.main.bounds.height * 0.12
    button.frame = CGRect(x: 0, y: 0, width: width, height: height)
    button.layer.cornerRadius = 0.4 * button.bounds.size.width
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 0.9
    button.clipsToBounds = true
    button.setTitle(NSLocalizedString("delete", comment: "Delete"), for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.textColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let okButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .blue
    let width = UIScreen.main.bounds.width * 0.25
    let height = UIScreen.main.bounds.height * 0.2
    button.frame = CGRect(x: 0, y: 0, width: width, height: height)
    button.layer.cornerRadius = 0.5 * button.bounds.size.width
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 0.9
    button.clipsToBounds = true
    button.setTitle(NSLocalizedString("ok", comment: "OK"), for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.textColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    return button
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .red
    let width = UIScreen.main.bounds.width * 0.25
    let height = UIScreen.main.bounds.height * 0.2
    button.frame = CGRect(x: 0, y: 0, width: width, height: height)
    button.layer.cornerRadius = 0.5 * button.bounds.size.width
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 0.9
    button.clipsToBounds = true
    button.setTitle(NSLocalizedString("cancel", comment: "Cancel"), for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.textColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    return button
  }()
  
  let toolBar: UIToolbar = {
    let toolBar = UIToolbar()
    var items = [UIBarButtonItem]()
    items.append(UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil))
    toolBar.setItems(items, animated: true)
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    return toolBar
  }()
  
  let leftBarButton = UIBarButtonItem(title: NSLocalizedString("employerback", comment: "< Employer"), style: .plain, target: nil, action: nil)
  
  init(employer: Employers) {
    self.employer = employer
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    setupUI()
    setupToolBar()
    setFields()
    navigationItem.leftBarButtonItem = leftBarButton
    
    imageView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
    imageView.addGestureRecognizer(gestureRecognizer)
    
    nameTextField.rx.text.orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
      .bind(to: okButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    leftBarButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.backToEmployer()
      }).disposed(by: disposeBag)
    
    editButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.edits(number: 1)
      }).disposed(by: disposeBag)
    
    deleteButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.showAlert()
      }).disposed(by: disposeBag)
    
    okButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.edit(self.nameTextField.text!, position: self.positionTextField.text, education: self.educationTextField.text, startDate: self.startDateTextField.text, image: self.imageView.image)
        self.edits(number: 0)
      }).disposed(by: disposeBag)
    
    cancelButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.setFields()
        self.edits(number: 0)
      }).disposed(by: disposeBag)
  }
  
}
