//
//  DuplicatesFoundView.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/15/23.
//

import UIKit

protocol DuplicatesFoundViewProtocol {
    func viewDuplicatesButtonPressed()
}

class DuplicatesFoundView: UIView {

    let kCONTENT_XIB_NAME = "DuplicatesFoundView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: DuplicatesFoundViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
   
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.isHidden = true
    }
    
    @IBAction func viewDuplicatesPressed(_ sender: UIButton) {
        delegate?.viewDuplicatesButtonPressed()
    }
   }

   extension UIView
   {
       func fixInView(_ container: UIView!) -> Void{
           self.translatesAutoresizingMaskIntoConstraints = false;
           self.frame = container.frame;
           self.layer.cornerRadius = self.frame.size.height/15
           container.addSubview(self);
           NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
           NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
           NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
           NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
       }
}
