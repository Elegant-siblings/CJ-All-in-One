//
//  ScanItemTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/30.
//

import UIKit

class ScanItemTableViewCell: UITableViewCell {
    
    static let identifier = "ScanItemTableViewCell"
    
    lazy var labelNum = MainLabel(type: .table).then {
        $0.textAlignment = .center
    }
    lazy var labelCategory = MainLabel(type: .table)
    lazy var labelReceivAddr = MainLabel(type: .table).then {
        $0.textAlignment = .center
    }
    lazy var imageState = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([labelNum,labelCategory,labelReceivAddr,imageState])
        
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(20)
        }
        labelCategory.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(80)
        }
        labelReceivAddr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(130)
            make.width.equalTo(160)
        }
        imageState.snp.makeConstraints { make in
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
