//
//  InfoTableViewCell.swift
//  CJ-NaverAPI-Example
//
//  Created by 정지윤 on 2022/07/23.
//

import UIKit
import Then

class FindPathBottomTableViewCell: UITableViewCell {
    static let identifier = "InfoTableViewCell"
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.gray
    }
    
    let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.gray
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
            make.leading.equalToSuperview().offset(75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
