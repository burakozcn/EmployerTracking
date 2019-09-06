import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var positionLabel: UILabel!
  @IBOutlet weak var educationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  var employers: Employers!
  
  override func awakeFromNib() {
    self.backgroundColor = .gray
    super.awakeFromNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame:frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
