//
//  ResultItemsTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit

class ResultItemsTableViewCell: UITableViewCell {
    
    static let identifier = "ResultItemsTableViewCell"
    
    lazy var viewNum = UIView()
    lazy var viewCategory = UIView()
    lazy var viewTo = UIView()
    
    lazy var labelNum = UILabel()
    lazy var labelCategory = UILabel()
    lazy var labelTo = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        viewNum.backgroundColor = .red
//        viewCategory.backgroundColor = .blue
//        viewTo.backgroundColor = .CjYellow
        contentView.addSubviews([viewNum,viewCategory,viewTo])
        viewNum.addSubviews([labelNum])
        viewCategory.addSubviews([labelCategory])
        viewTo.addSubviews([labelTo])
        
        viewNum.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalToSuperview().offset(2)
            make.width.equalTo(35)
        }
        viewCategory.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalTo(viewNum.snp.trailing)
            make.width.equalTo(60)
        }
        viewTo.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalTo(viewCategory.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        _ = [labelNum,labelCategory,labelTo].map { label in
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center

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
