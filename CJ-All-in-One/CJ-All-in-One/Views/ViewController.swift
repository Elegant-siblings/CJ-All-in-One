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

class ViewController: UIViewController {
    
    lazy var nextButton = UIButton().then {
        $0.backgroundColor = .red
        $0.setTitle("go to next view", for: .normal)
        $0.addTarget(self, action: #selector(touchup), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.barTintColor = .red
//        navigationController?.navigationBar.tintColor = .red
        navigationController?.navigationBar.backgroundColor = .red
//        navigationController?.navigationItem.title = "Main"
//        navigationController?.navigationBar.topItem?.title = "Main"
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func touchup() {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }


}

