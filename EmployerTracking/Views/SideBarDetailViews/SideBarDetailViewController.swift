import UIKit

class SideBarDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  let story: Story
  let pickers = ["This", "That", "These", "Those"]
  
  func label(text: String, font: UIFont) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.adjustsFontSizeToFitWidth = true
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  func textField(placeholder: String, isEnabled: Bool) -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .default
    textField.backgroundColor = .white
    textField.textAlignment = .center
    textField.placeholder = placeholder
    textField.isEnabled = isEnabled
    return textField
  }
  
  let textView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    return pickerView
  }()
  
  init(story: Story) {
    self.story = story
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
    switch story {
    case .about:
      aboutSetup()
    case .settings:
      settingsSetup()
    case .support:
      supportSetup()
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickers.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickers[row]
  }
  
  func aboutSetup() {
    let height = UIScreen.main.bounds.size.height
    let guide = view.safeAreaLayoutGuide
    
    let titleLabel = label(text: "About Us", font: .boldSystemFont(ofSize: 24))
    
    view.addSubview(titleLabel)
    view.addSubview(textView)
    
    titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: -height / 4).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    textView.topAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -height / 3).isActive = true
    textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  
  func settingsSetup() {
    let height = UIScreen.main.bounds.size.height
    let guide = view.safeAreaLayoutGuide
    
    let settingLabel = label(text: "What to choose?", font: .boldSystemFont(ofSize: 23))
    
    view.addSubview(settingLabel)
    view.addSubview(pickerView)
    
    settingLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: height * 0.2).isActive = true
    settingLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor).isActive = true
    settingLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -height * 0.05).isActive = true
  
    pickerView.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor).isActive = true
    pickerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -height * 0.2).isActive = true
  }
  
  func supportSetup() {
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    let guide = view.safeAreaLayoutGuide
    
    let companyLabel = label(text: "Your Company", font: .systemFont(ofSize: 20))
    let complaintLabel = label(text: "Please tell your complaint", font: .systemFont(ofSize: 20))
    
    let companyTextField = textField(placeholder: "Your Company", isEnabled: true)
    let complaintTextField = textField(placeholder: "Please feel free to contact us.", isEnabled: true)
    
    view.addSubview(companyLabel)
    view.addSubview(companyTextField)
    view.addSubview(complaintLabel)
    view.addSubview(complaintTextField)
    
    
    companyLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: height * 0.3).isActive = true
    companyLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: width * 0.15).isActive = true
    companyLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -width * 0.15).isActive = true
    companyLabel.bottomAnchor.constraint(equalTo: companyTextField.topAnchor, constant: -height * 0.05).isActive = true
    
    companyTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: width * 0.15).isActive = true
    companyTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -width * 0.15).isActive = true
    companyTextField.bottomAnchor.constraint(equalTo: complaintLabel.topAnchor, constant: -height * 0.12).isActive = true
    
    complaintLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: width * 0.15).isActive = true
    complaintLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -width * 0.15).isActive = true
    complaintLabel.bottomAnchor.constraint(equalTo: complaintTextField.topAnchor, constant: -height * 0.05).isActive = true
    
    complaintTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: width * 0.15).isActive = true
    complaintTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -width * 0.15).isActive = true
    complaintTextField.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -height * 0.25).isActive = true
  }
}
