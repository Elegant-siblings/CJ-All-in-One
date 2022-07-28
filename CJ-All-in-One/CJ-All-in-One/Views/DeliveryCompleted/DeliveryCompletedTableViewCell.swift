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
    
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.gray
    }
    
    let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.gray
>>>>>>> 377993d (test)
=======
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
>>>>>>> 9f2b72d (test)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9f2b72d (test)
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
<<<<<<< HEAD
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubviews([numLabel, titleLabel, contentLabel, checkImage, confirmLabel])
        
        setConstraints()
=======
=======
>>>>>>> 9f2b72d (test)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubviews([numLabel, titleLabel, contentLabel, checkImage, confirmLabel])
        
<<<<<<< HEAD
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(75)
        }
>>>>>>> 377993d (test)
=======
        setConstraints()
>>>>>>> 9f2b72d (test)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9f2b72d (test)
    
    
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
<<<<<<< HEAD
=======
>>>>>>> 377993d (test)
=======
>>>>>>> 9f2b72d (test)
}

