import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EmployerViewController: UICollectionViewController {
  private let identifier = "CollectionCell"
  private let disposeBag = DisposeBag()
  var viewModel: EmployerListViewModel!
  
  let category: Categories
  
  let flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 300, height: 170)
    layout.minimumInteritemSpacing = 2
    layout.minimumLineSpacing = 5
    layout.scrollDirection = .vertical
    return layout
  }()
  
  let leftBarButton = UIBarButtonItem(title: "< Category", style: .plain, target: nil, action: nil)
  let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil)
  
  let toolBar: UIToolbar = {
    let toolBar = UIToolbar()
    var items = [UIBarButtonItem]()
    items.append(UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil))
    toolBar.setItems(items, animated: true)
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    return toolBar
  }()
  
  init(category: Categories) {
    self.category = category
    super.init(collectionViewLayout: flowLayout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.hidesBackButton = true
    navigationItem.rightBarButtonItem = rightBarButton
    navigationItem.leftBarButtonItem = leftBarButton
    setupToolBar()
    
    viewModel = EmployerListViewModel(category: category)
    
    navigationController?.navigationBar.prefersLargeTitles = true
    self.title = category.name
    
    self.collectionView.backgroundColor = .white
    self.collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
    self.collectionView.delegate = nil
    self.collectionView.dataSource = nil
    self.collectionView.reloadData()
    
    Observable.just(viewModel.sections)
      .bind(to: self.collectionView.rx.items(dataSource: viewModel.source(self.collectionView)))
      .disposed(by: disposeBag)
     
    rightBarButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.addEmployer()
      }).disposed(by: disposeBag)
    
    leftBarButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.backToCategory()
      }).disposed(by: disposeBag)
    
    self.collectionView.rx.itemSelected.asObservable()
      .subscribe(onNext: { [unowned self] (index) in
        let cell = self.collectionView.cellForItem(at: index) as? CustomCollectionViewCell
        let employer = cell?.employers
        self.viewModel.openDetail(index.row, category: self.category, employers: employer!)
      }).disposed(by: disposeBag)
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
