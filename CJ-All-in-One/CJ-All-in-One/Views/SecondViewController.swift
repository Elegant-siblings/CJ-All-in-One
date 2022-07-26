//
//  SecondViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/25.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let uiLabel = UILabel().then { label in
            label.text = "second view"
        }
        view.addSubview(uiLabel)
        uiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
