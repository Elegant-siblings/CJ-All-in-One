//
//  InfoTableViewCell.swift
//  CJ-NaverAPI-Example
//
//  Created by 정지윤 on 2022/07/23.
//

import UIKit
import Then
<<<<<<< HEAD
<<<<<<< HEAD
import SnapKit
=======
>>>>>>> 377993d (test)
=======
import SnapKit
>>>>>>> 36da96d (test)

class FindPathBottomTableViewCell: UITableViewCell {
    static let identifier = "InfoTableViewCell"
    
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 36da96d (test)
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
<<<<<<< HEAD
    }
    
=======
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.gray
    }
    
    let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.gray
    }
>>>>>>> 377993d (test)
=======
    }
    
>>>>>>> 36da96d (test)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> 377993d (test)
=======
>>>>>>> 36da96d (test)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
<<<<<<< HEAD
<<<<<<< HEAD
        self.contentView.addSubviews([numLabel,titleLabel,contentLabel,wayLabel, checkImage])
        
        setConstraints()
=======
        self.contentView.addSubviews([titleLabel,contentLabel])
        
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
        self.contentView.addSubviews([numLabel,titleLabel,contentLabel,wayLabel, checkImage])
        
        setConstraints()
>>>>>>> 36da96d (test)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 36da96d (test)
    
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
<<<<<<< HEAD
=======
>>>>>>> 377993d (test)
=======
>>>>>>> 36da96d (test)
}
