//
//  ViewController.swift
//  CJ-All-in-One
//
//  Created by 최원준 on 2022/07/24.
//

import UIKit
import SnapKit
import NMapsMap
import Then
import Alamofire
import PanModal

class MainViewController: UIViewController {
    
    // -MARK: variables
    var lists = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh"]
    let detailTypes = ["모집내역", "배송내역"]
    
    
    // -MARK: UIViews
    lazy var uiTableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var uiApplyButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .CjWhite
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    lazy var distributeBar: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(rgb: 0xB4B4B4)
        return view
    } ()
    
    // -MARK: UIButtons
    lazy var buttonApply: UIButton = {
        let button = UIButton()
        button.backgroundColor = .CjYellow
        button.layer.cornerRadius = 10
        button.setTitle("모집 신청하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    } ()
    
    lazy var buttonSort: UIButton = {
        let button = UIButton()
        button.backgroundColor = .CjWhite
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor(rgb: 0x8B8B8B).cgColor
        let customButtonLabel = NSMutableAttributedString(
            string: " 정렬",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x8B8B8B),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10,weight: .bold)
            ])
        button.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        button.tintColor = UIColor(rgb: 0x8B8B8B)
        button.setAttributedTitle(customButtonLabel, for: .normal)
        button.layer.borderWidth = 0.5
        return button
    } ()
    
    lazy var buttonMenu: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.CjRed], for: .normal)
        return item
    } ()
    
    lazy var buttonSiljeock: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playTapped))
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.CjRed], for: .normal)
        return item
    } ()
    
    // -MARK: Others
    lazy var tableHistory: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.register(DeliveryDetailTableViewCell.self, forCellReuseIdentifier: DeliveryDetailTableViewCell.identifier)
        table.rowHeight = 100
        table.backgroundColor = .CjWhite
        return table
    } ()
    
    lazy var SCDetailType: UISegmentedControl = {
        let sc: UISegmentedControl = UISegmentedControl(items: detailTypes)
        sc.backgroundColor = .CjWhite
        sc.layer.cornerRadius = 3
        sc.selectedSegmentTintColor = .CjRed
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.CjRed, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .selected)
        let backgroundImage = UIImage()
        let colorView = UIView()
        colorView.backgroundColor = .CjRed
//        let foregroundImage = colorView.asImage()
        sc.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)

        sc.selectedSegmentIndex = 0
        sc.apportionsSegmentWidthsByContent = false
        sc.addTarget(self, action: #selector(detailTypeChanged(type:)), for: UIControl.Event.valueChanged)
        return sc
    }()
    
    // -MARK: Actions
    @objc
    func detailTypeChanged(type: UISegmentedControl) {
        print(detailTypes[type.selectedSegmentIndex])
    }
    
    @objc
    func addTapped(type: UISegmentedControl) {
        print("add Tapped")
    }
    
    @objc
    func playTapped(type: UISegmentedControl) {
        print("play Tapped")
    }
    
    @objc func touchUpApplyButton() {
        print("모집 신청하기")
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .CjWhite
        navigationController?.navigationBar.backgroundColor = .deppBlue
        navigationController?.navigationBar.barStyle = .default
//        navigationController?.navigationItem.title = "Main"
        
        self.view.addSubviews([
            SCDetailType,
            buttonSort,
            distributeBar,
            uiTableContainer,
            uiApplyButtonContainer,
            buttonApply
        ])
        
        self.uiTableContainer.addSubview(tableHistory)

        setConstraints()

    }

    // -MARK: Settings
    private func setConstraints() {
        SCDetailType.snp.makeConstraints { make in
            make.leading.equalTo(21)
            make.top.equalTo(100)
            make.height.equalTo(23)
            make.width.equalTo(130)
        }
        
        buttonSort.snp.makeConstraints { make in
            make.centerY.equalTo(SCDetailType)
            make.leading.equalTo(314)
            make.height.equalTo(SCDetailType)
            make.width.equalTo(52)
        }
        
        distributeBar.snp.makeConstraints { make in
            make.top.equalTo(132)
            make.leading.equalTo(21)
            make.height.equalTo(1)
            make.width.equalTo(345)
        }
        
        uiTableContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(141)
            make.width.equalToSuperview()
            make.bottom.equalTo(uiApplyButtonContainer.snp.top)
        }
        
        uiApplyButtonContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(116)
            make.bottom.equalToSuperview()
        }
        buttonApply.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.top).offset(754)
            make.width.equalTo(primaryButtonWidth)
            make.height.equalTo(primaryButtonHeight)
        }
        tableHistory.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
}



// -MARK: Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableLabels.count
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailTableViewCell.identifier, for: indexPath) as! DeliveryDetailTableViewCell
//        cell.labelDate.text = tableLabels[indexPath.row]
//        cell.labelName.text = names[indexPath.row]
//        cell.labelNumber.text = numbers[indexPath.row]
//        cell.labelFrom.text = details[indexPath.row].from + " >> " + details[indexPath.row].to
//        cell.labelState.text = states[indexPath.row]
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        cell.backgroundColor = .CjWhite
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("click: \(tableLabels[indexPath.row])")
//        print(lists[indexPath.row])
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else { return }
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        vc.detail = details[indexPath.row]
//        self.present(vc, animated: true, completion: nil)
    }
}

