//
//  AssignedTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/28.
//

import UIKit
import SnapKit

public enum ButtonType {
    case add
    case remove
}

protocol AssignCellDelegate: AnyObject {
    func addItems(sender: UIButton, index: Int)
    func removeItems(sender: UIButton, index: Int)
}

class AssignedTableViewCell: UITableViewCell {
    
    static let identifier = "AssignedTableViewCell"
    let buttonRadius = CGFloat(12)
    
    var cellDelegate: AssignCellDelegate?
    var pk: Int = 0
    var buttonType: ButtonType = .add
    var rowIndex = 0
    var isAddbuttonEnabled = 1
    
    lazy var viewNum = UIView()
    lazy var viewCategory = UIView()
    lazy var viewReceivAddr = UIView()
    
    lazy var labelNum = MainLabel(type: .table)
    lazy var labelCategory = MainLabel(type: .table)
    lazy var labelReceivAddr = MainLabel(type: .table)
    
    lazy var button = UIButton().then {
        $0.layer.cornerRadius = buttonRadius
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        $0.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([viewNum,viewCategory,viewReceivAddr, button])
        
        viewNum.addSubviews([labelNum])
        viewCategory.addSubviews([labelCategory])
        viewReceivAddr.addSubviews([labelReceivAddr])
        
        viewNum.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.width.equalTo(35)
        }
        viewCategory.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalTo(viewNum.snp.trailing).offset(3)
            make.width.equalTo(60)
        }
        viewReceivAddr.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalTo(viewCategory.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        _ = [labelNum,labelCategory,labelReceivAddr].map { label in
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
            label.textAlignment = .center
        }
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.height.width.equalTo(buttonRadius*2)
        }
    }
    
    @objc func touchUpAddButton(sender: UIButton) {
        cellDelegate?.addItems(sender: sender, index: rowIndex)
    }
    @objc func touchUpRemoveButton(sender: UIButton) {
        cellDelegate?.removeItems(sender: sender, index: rowIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch buttonType {
        case .add:
            button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            button.addTarget(self, action: #selector(touchUpAddButton(sender:)), for: .touchUpInside)
            button.isEnabled = isAddbuttonEnabled == 1 ? true : false
            button.tintColor = .CjBlue
        case .remove:
            button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            button.addTarget(self, action: #selector(touchUpRemoveButton(sender:)), for: .touchUpInside)
            button.tintColor = .CjRed
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
