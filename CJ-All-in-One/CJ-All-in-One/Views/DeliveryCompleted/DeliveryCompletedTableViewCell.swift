//
//  DeliveryCompletedTableViewCell.swift
//  CJ-NaverAPI-Example
//
//  Created by 정지윤 on 2022/07/25.
//

import UIKit
import Then
import SnapKit

class DeliveryCompletedTableViewCell: UITableViewCell {
    static let identifier = "DeliveryCompletedTableViewCell"
    
    let numLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 12)
        $0.textColor = .gray
    }
    let titleLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 12)
        $0.textColor = .gray
    }
    let contentLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 12)
        $0.textColor = .gray
    }
    let confirmLabel = MainLabel(type: .main).then {
        $0.text = "확인"
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 12)
        $0.textColor = .lightGray
        
    }
    let checkImage = UIImageView().then {
        $0.image = UIImage(named: "CellCheck")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubviews([numLabel, titleLabel, contentLabel, checkImage, confirmLabel])
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(numLabel)
            make.leading.equalTo(numLabel.snp.trailing).offset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(numLabel)
            make.leading.equalTo(numLabel.snp.leading).offset(120)
            make.trailing.equalTo(checkImage.snp.leading).offset(-20)
        }
        checkImage.snp.makeConstraints { make in
            make.centerY.equalTo(numLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        confirmLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}

