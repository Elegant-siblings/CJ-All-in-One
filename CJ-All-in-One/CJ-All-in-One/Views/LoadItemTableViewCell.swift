//
//  LoadItemTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit

class LoadItemTableViewCell: UITableViewCell {
    
    static let identifier = "LoadItemTableViewCell"
    
    lazy var viewNum = UIView()
    lazy var viewCategory = UIView()
    lazy var viewReceivAddr = UIView()
    
    lazy var labelNum = MainLabel(type: .table).then {
        $0.textAlignment = .center
    }
    lazy var labelCategory = MainLabel(type: .table)
    lazy var labelReceivAddr = MainLabel(type: .table).then {
        $0.textAlignment = .center
    }
    lazy var labelSeat = MainLabel(type: .table).then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([labelNum,labelCategory,labelReceivAddr,labelSeat])
        
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(20)
        }
        labelCategory.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(70)
        }
        labelReceivAddr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(130)
            make.width.equalTo(160)
        }
        labelSeat.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
