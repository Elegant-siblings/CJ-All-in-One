//
//  PackageDeliveryTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/27.
//

import UIKit

class PackageDeliveryTableViewCell: UITableViewCell {
    static let identifier = "PackageDeliveryTableViewCell"
    
    let titleLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 10)
        $0.textColor = UIColor.gray
    }
    
    let contentLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 10)
        $0.textColor = UIColor.black
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubviews([titleLabel,contentLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
