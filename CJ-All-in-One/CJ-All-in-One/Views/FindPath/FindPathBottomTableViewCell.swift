//
//  InfoTableViewCell.swift
//  CJ-NaverAPI-Example
//
//  Created by 정지윤 on 2022/07/23.
//

import UIKit
import Then
import SnapKit

class FindPathBottomTableViewCell: UITableViewCell {
    static let identifier = "InfoTableViewCell"
    
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
    let wayLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.medium, size: 12)
        $0.textColor = .gray
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubviews([numLabel,titleLabel,contentLabel,wayLabel, checkImage])
        
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
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
        wayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(numLabel)
            make.leading.equalTo(checkImage.snp.leading).offset(-20)
        }
        checkImage.snp.makeConstraints { make in
            make.centerY.equalTo(numLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
}
