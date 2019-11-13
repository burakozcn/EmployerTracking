import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CategoryViewController: UITableViewController {
  
  private let disposeBag = DisposeBag()
  private let identifier = "TableCell"
  var viewModel: CategoryListViewModel!
  var edit = false
  
  let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  let leftBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
  
  init() {
    let interval2 = Date.timeIntervalSinceReferenceDate
    let f: Double = interval2 - AppDelegate.interval1
    let s = String(format: "%.7f", f)
    print("TIME = \(s)")
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    navigationItem.rightBarButtonItem = rightBarButton
    navigationItem.leftBarButtonItem = leftBarButton

    self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: identifier)
    
    self.tableView.reloadData()
    self.tableView.delegate = nil
    self.tableView.dataSource = nil
    
    let initialState = CategoryListViewModel()
    
    let deleteCommand = self.tableView.rx.itemDeleted.asObservable()
      .map(TableViewEditing.DeleteItem)
    
    Observable.of(deleteCommand)
      .merge()
      .scan(initialState) { (state: CategoryListViewModel, command: TableViewEditing) -> CategoryListViewModel in
        return state.delete(command: command)
      }.startWith(initialState)
      .map { $0.sections }
      .share(replay: 1)
      .bind(to: self.tableView.rx.items(dataSource: viewModel.source(self.tableView)))
      .disposed(by: disposeBag)
    
    self.tableView.rx.itemSelected.asObservable()
      .subscribe(onNext: { [unowned self] (index) in
        let cell = self.tableView.cellForRow(at: index) as? CustomTableViewCell
        let category = cell?.category
        self.viewModel.openDetail(index.row, category: category!)
      }).disposed(by: disposeBag)
    
    rightBarButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.addCat()
      }).disposed(by: disposeBag)
    
    leftBarButton.rx.tap.asObservable()
      .subscribe(onNext: { [unowned self] _ in
        if self.edit == false {
          self.tableView.setEditing(true, animated: true)
          self.edit = true
        } else {
          self.tableView.setEditing(false, animated: true)
          self.edit = false
        }
      }).disposed(by: disposeBag)
    
    self.tableView.rowHeight = 144
  }
  
}

