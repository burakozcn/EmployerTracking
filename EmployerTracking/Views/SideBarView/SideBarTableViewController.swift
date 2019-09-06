import UIKit
import RxSwift
import RxCocoa

class SideBarTableViewController: UITableViewController {
  let disposeBag = DisposeBag()
  var viewModel: SideBarTableViewModel!
  
  let rowData = ["Settings", "Support", "About"]
  let CellIdentifier = "SideBarCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.frame.size.width = UIScreen.main.bounds.width / 3
    
    self.tableView.rowHeight = 80
    self.tableView.register(UINib(nibName: "SideBarTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    
    self.tableView.rx.itemSelected.asObservable()
      .subscribe(onNext: { [unowned self] index in
        self.viewModel = SideBarTableViewModel()
        let name = self.rowData[index.row]
        self.viewModel.openSideDetail(name)
      }).disposed(by: disposeBag)
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: SideBarTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! SideBarTableViewCell
    cell.nameLabel.text = rowData[indexPath.row]
    return cell
  }
}
