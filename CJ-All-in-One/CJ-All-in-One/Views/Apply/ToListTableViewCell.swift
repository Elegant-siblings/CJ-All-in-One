//
//  ToListTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit

let removeButtonRadius = CGFloat(10)

protocol ToListDelegate {
    func removeTo(index: Int)
}

class ToListTableViewCell: UITableViewCell {
    
    static let identifier = "ToListTableViewCell"
    let buttonRadius = CGFloat(23)
    var listDelegate : ToListDelegate?
    var rowIndex = 0
    
    lazy var labelNum = MainLabel(type: .table)
    lazy var labelTo = MainLabel(type: .table)
    lazy var buttonRemove = UIButton().then {
        $0.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        $0.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        $0.tintColor = .CjRed
        $0.addTarget(self, action: #selector(touchUpRemoveButton), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([labelNum,labelTo,buttonRemove])
        
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        labelTo.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        buttonRemove.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonRadius)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    @objc func touchUpRemoveButton() {
            listDelegate?.removeTo(index: self.rowIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
}
