//
//  ToListTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit

let removeButtonRadius = CGFloat(10)

class ToListTableViewCell: UITableViewCell {
    
    static let identifier = "ToListTableViewCell"
    
    var fontSize = CGFloat(13)
    var fontColor = UIColor.tableContentTextColor
    var rowIndex = 0
    
    lazy var labelNum = UILabel()
    lazy var labelTo = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([labelNum,labelTo])
        print("init \(rowIndex)")
        
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        labelTo.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        _ = [labelNum,labelTo].map {
            $0.font = .systemFont(ofSize: fontSize, weight: .bold)
            $0.textColor = fontColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("prepareForReuse")
    }
}
