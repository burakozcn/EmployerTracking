import RxSwift
import RxCocoa
import UIKit

class EmployerAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  let disposeBag = DisposeBag()
  var viewModel: EmployerAddViewModel!
  var datePicker: UIDatePicker!
  let category: Categories
  
  init(category: Categories) {
    self.category = category
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    textField.text? = ""
    return textField
  }()
  
  let positionTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.text? = ""
    return textField
  }()
  
  let educationTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.text = ""
    return textField
  }()
  
  let startDateTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = .white
    textField.textAlignment = .center
    return textField
  }()
  
  let button: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Submit", for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
    showDatePicker()
    
    imageView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
    imageView.addGestureRecognizer(gestureRecognizer)
    
    nameTextField.rx.text.orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
      .bind(to: button.rx.isEnabled)
      .disposed(by: disposeBag)
    
    button.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.saveEmployer(name: self.nameTextField.text, position: self.positionTextField.text, education: self.educationTextField.text, startDate: self.startDateTextField.text, imageView: self.imageView, category: self.category)
        self.viewModel.showAlert()
      }).disposed(by: disposeBag)
  }
  
  func setupUI() {
    let readingGuide = view.readableContentGuide
    let safeGuide = view.safeAreaLayoutGuide
    datePicker = UIDatePicker()
    
    let nameLabel = label(text: "Employer Name:     ")
    let positionLabel = label(text: "Position:       ")
    let educationLabel = label(text: "Education:      ")
    let startDateLabel = label(text: "Start Date:      ")
    
    view.addSubview(nameLabel)
    view.addSubview(positionLabel)
    view.addSubview(educationLabel)
    view.addSubview(startDateLabel)
    view.addSubview(nameTextField)
    view.addSubview(positionTextField)
    view.addSubview(educationTextField)
    view.addSubview(startDateTextField)
    view.addSubview(button)
    view.addSubview(imageView)
    
    educationLabel.topAnchor.constraint(equalTo: safeGuide.centerYAnchor).isActive = true
    educationLabel.leadingAnchor.constraint(equalTo: readingGuide.leadingAnchor).isActive = true
    educationLabel.trailingAnchor.constraint(equalTo: educationTextField.leadingAnchor).isActive = true
    
    educationTextField.topAnchor.constraint(equalTo: safeGuide.centerYAnchor).isActive = true
    educationTextField.trailingAnchor.constraint(equalTo: readingGuide.trailingAnchor).isActive = true
    
    positionLabel.bottomAnchor.constraint(equalTo: educationLabel.topAnchor, constant: -15).isActive = true
    positionLabel.leadingAnchor.constraint(equalTo: readingGuide.leadingAnchor).isActive = true
    positionLabel.trailingAnchor.constraint(equalTo: positionTextField.leadingAnchor).isActive = true
    
    positionTextField.bottomAnchor.constraint(equalTo: educationLabel.topAnchor, constant: -15).isActive = true
    positionTextField.trailingAnchor.constraint(equalTo: readingGuide.trailingAnchor).isActive = true
    
    nameLabel.bottomAnchor.constraint(equalTo: positionLabel.topAnchor, constant: -15).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: readingGuide.leadingAnchor).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
    
    nameTextField.bottomAnchor.constraint(equalTo: positionLabel.topAnchor, constant: -15).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: readingGuide.trailingAnchor).isActive = true
    
    startDateLabel.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 15).isActive = true
    startDateLabel.leadingAnchor.constraint(equalTo: readingGuide.leadingAnchor).isActive = true
    startDateLabel.trailingAnchor.constraint(equalTo: startDateTextField.leadingAnchor).isActive = true
    
    startDateTextField.topAnchor.constraint(equalTo: educationTextField.bottomAnchor, constant: 15).isActive = true
    startDateTextField.leadingAnchor.constraint(equalTo: startDateLabel.trailingAnchor).isActive = true
    
    button.centerXAnchor.constraint(equalTo: readingGuide.centerXAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.widthAnchor.constraint(equalToConstant: 150).isActive = true
    button.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 40).isActive = true
    
    imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -45).isActive = true
    imageView.centerXAnchor.constraint(equalTo: readingGuide.centerXAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.2).isActive = true
    imageView.widthAnchor.constraint(equalTo: readingGuide.widthAnchor, multiplier: 0.4).isActive = true
  }
  
  func showDatePicker(){
    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.maximumDate = Date()
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
    
    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
    
    startDateTextField.inputAccessoryView = toolbar
    startDateTextField.inputView = datePicker
  }
  
  @objc func donedatePicker(){
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    startDateTextField.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  @objc func cancelDatePicker(){
    self.view.endEditing(true)
  }
  
  func showAlert() {
    viewModel = EmployerAddViewModel(category: category)
    let alert = UIAlertController(title: "Success", message: "Saved successfully.", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
      self.viewModel.backToEmployer()
    }))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
  }
  
  @objc func tapGesture(_ sender: UITapGestureRecognizer) {
    viewModel = EmployerAddViewModel(category: category)
    viewModel.openGallery(viewController: self)
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imageView.image = image
    } else {
      print("Error")
    }
    self.dismiss(animated: true, completion: nil)
  }
}
