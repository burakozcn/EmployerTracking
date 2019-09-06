import UIKit
import RxSwift

class MainViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  var leftViewController: UIViewController!
  var masterViewController: UIViewController!
  var overlap = UIScreen.main.bounds.size.width / 3
  var scrollView: UIScrollView!
  var firstTime = true
  var rightBarButton: UIBarButtonItem?
  var leftBarButton: UIBarButtonItem?
  
  let toolBar: UIToolbar = {
    let toolBar = UIToolbar()
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    return toolBar
  }()
  
  let toolBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
  
  required init(coder aDecoder: NSCoder) {
    assert(false, "Use init(leftViewController:mainViewController:overlap:)")
    super.init(coder: aDecoder)!
  }
  
  init(leftViewController: UIViewController, mainViewController: UIViewController) {
    self.leftViewController = leftViewController
    self.masterViewController = mainViewController
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black
    navigationItem.rightBarButtonItem = rightBarButton
    navigationItem.leftBarButtonItem = leftBarButton
    
    setupScrollView()
    setupViewControllers()
    setupToolBar()
    
    var items = [UIBarButtonItem]()
    items.append(toolBarButton)
    toolBar.setItems(items, animated: true)
    
    toolBarButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.toggleLeftAnimated(true)
      }).disposed(by: disposeBag)
    
    closeMenuAnimated(true)
  }
  
  override func viewDidLayoutSubviews() {
    if firstTime {
      firstTime = false
      scrollView.setContentOffset(CGPoint(x: leftViewController.view.frame.width + overlap, y: 0), animated: true)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    closeMenuAnimated(animated)
  }
  
  func closeMenuAnimated(_ animated: Bool) {
    scrollView.setContentOffset(CGPoint(x: leftViewController.view.frame.width, y: 0), animated: animated)
  }
  
  func leftMenuIsOpen() -> Bool {
    return scrollView.contentOffset.x == 0
  }
  
  func openLeftMenuAnimated(_ animated: Bool) {
    scrollView.setContentOffset(CGPoint(x:0, y: 0), animated: animated)
  }
  
  func toggleLeftAnimated(_ animated: Bool) {
    if leftMenuIsOpen() {
      closeMenuAnimated(animated)
    } else {
      openLeftMenuAnimated(animated)
    }
  }
  
  func setupScrollView() {
    scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isPagingEnabled = true
    scrollView.bounces = false
    view.addSubview(scrollView)
    
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView])
    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView])
    NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
  }
  
  func setupViewControllers() {
    addViewController(leftViewController)
    addViewController(masterViewController)
    
    let views: [String: UIView] = ["left": leftViewController.view, "main": masterViewController.view, "outer": view]
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[left][main(==outer)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
    let leftWidthConstraint = NSLayoutConstraint(item: leftViewController.view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: -overlap)
    masterViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    masterViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    NSLayoutConstraint.activate(horizontalConstraints + [leftWidthConstraint])
  }
  
  private func addViewController(_ viewController: UIViewController) {
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(viewController.view)
    addChild(viewController)
    viewController.didMove(toParent: self)
  }
  
  func setupToolBar() {
    view.addSubview(toolBar)
    
    let guide = self.view.safeAreaLayoutGuide
    toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    toolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }
}
