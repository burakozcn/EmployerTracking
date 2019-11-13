import UIKit

extension DetailViewController {
  
  func setupToolBar() {
    view.addSubview(toolBar)
    
    let guide = self.view.safeAreaLayoutGuide
    toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    toolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }
  
  func setFields() {
    nameTextField.text = employer.name
    positionTextField.text = employer.position
    educationTextField.text = employer.education
    startDateTextField.text = employer.startDate.toString(dateFormat: "dd/MM/yyyy")
    
    let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let path = storeURL.appendingPathComponent("\(employer.name).png").path
    imageView.image = UIImage(contentsOfFile: path)
  }
  
  func edits(number: Int) {
    if number == 1 {
      nameTextField.isEnabled = true
      positionTextField.isEnabled = true
      educationTextField.isEnabled = true
      startDateTextField.isEnabled = true
      editButton.isHidden = true
      deleteButton.isHidden = true
      okButton.isHidden = false
      cancelButton.isHidden = false
    }
    else {
      nameTextField.isEnabled = false
      positionTextField.isEnabled = false
      educationTextField.isEnabled = false
      startDateTextField.isEnabled = false
      editButton.isHidden = false
      deleteButton.isHidden = false
      okButton.isHidden = true
      cancelButton.isHidden = true
    }
  }
  
  func setupUI() {
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let nameLabel = label(text: NSLocalizedString("name", comment: "Name:     "))
    let positionLabel = label(text: NSLocalizedString("position", comment: "Position:       "))
    let educationLabel = label(text: NSLocalizedString("education", comment: "Education:   "))
    let startDateLabel = label(text: NSLocalizedString("startdate", comment: "Start Date:   "))
    
    view.addSubview(imageView)
    view.addSubview(nameLabel)
    view.addSubview(positionLabel)
    view.addSubview(educationLabel)
    view.addSubview(startDateLabel)
    view.addSubview(nameTextField)
    view.addSubview(positionTextField)
    view.addSubview(educationTextField)
    view.addSubview(startDateTextField)
    view.addSubview(editButton)
    view.addSubview(deleteButton)
    view.addSubview(okButton)
    view.addSubview(cancelButton)
    
    imageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 60).isActive = true
    imageView.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.27).isActive = true
    imageView.widthAnchor.constraint(equalTo: readGuide.widthAnchor, multiplier: 0.5).isActive = true
    imageView.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    
    nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
    
    nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
    nameTextField.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    
    positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
    positionLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    positionLabel.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    positionLabel.trailingAnchor.constraint(equalTo: positionTextField.leadingAnchor).isActive = true
    
    positionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4).isActive = true
    positionTextField.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    positionTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    
    educationLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 4).isActive = true
    educationLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    educationLabel.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    educationLabel.trailingAnchor.constraint(equalTo: educationTextField.leadingAnchor).isActive = true
    
    educationTextField.topAnchor.constraint(equalTo: positionTextField.bottomAnchor, constant: 4).isActive = true
    educationTextField.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    educationTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    
    startDateLabel.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 4).isActive = true
    startDateLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    startDateLabel.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    startDateLabel.trailingAnchor.constraint(equalTo: startDateTextField.leadingAnchor).isActive = true
    
    startDateTextField.topAnchor.constraint(equalTo: educationTextField.bottomAnchor, constant: 4).isActive = true
    startDateTextField.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    startDateTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    
    editButton.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: height * 0.03).isActive = true
    editButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.55).isActive = true
    editButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.20).isActive = true
    editButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -height * 0.2).isActive = true
    
    deleteButton.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: height * 0.03).isActive = true
    deleteButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.20).isActive = true
    deleteButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.55).isActive = true
    deleteButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -height * 0.2).isActive = true
    
    okButton.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: height * 0.03).isActive = true
    okButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.55).isActive = true
    okButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.20).isActive = true
    okButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -height * 0.2).isActive = true
    
    cancelButton.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: height * 0.03).isActive = true
    cancelButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.20).isActive = true
    cancelButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.55).isActive = true
    cancelButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -height * 0.2).isActive = true
  }
  
  func showAlert() {
    viewModel = DetailViewModel(employers: employer)
    let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this employer?", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
      self.viewModel.delete()
    }))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
  }
  
  func deleteAlert(category: Categories) {
    viewModel = DetailViewModel(employers: employer)
    let alert = UIAlertController(title: "Success", message: "Employer has been deleted successfully.", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
      self.viewModel.backtoCollection(category: category)
    }))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
  }
  
  @objc func tapGesture(_ sender: UITapGestureRecognizer) {
    viewModel = DetailViewModel(employers: employer)
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
