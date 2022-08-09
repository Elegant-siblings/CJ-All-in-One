//
//  PackageDetailViewController.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/27.
//

import Foundation
import UIKit
import SnapKit
import Then
import DropDown

class PackageDetailViewController: UIViewController {
    
    lazy var dataManager: PackageDetailDataManager = PackageDetailDataManager(delegate: self)
    
    // Table 정보
    var packageItemInfo : PackageResponse!
    let tableRowHeight = CGFloat(40)
    let titles = ["배송기사", "송장번호", "상품정보", "보내는 분", "받는 분", "보내는 주소", "받는 주소", "요청 사항"]
    var contents : [String] = []
    let deliveryTitles = ["배송현황", "배송 완료 시각", "수취 방법", "수령인", "사진"]
    var deliveryContents : [String] = [""]
    var deliveryImgStr : String?
    var deliveryPK : Int?
    var photoURL : String?
    var complete: Int?
    var receipt: String?
    var recipient: String?
    
    let dropDown1 = DropDown()
    let dropDown2 = DropDown()
    
    
    lazy var viewScrollContain = UIView()
    lazy var scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = false
        $0.bounces = $0.contentOffset.y > 0
    }
    lazy var viewContent = UIView()
    
    let navigationView = UIView().then {
        $0.backgroundColor = .deppBlue
    }
    let completedLabel = MainLabel(type: .main).then {
        $0.text = "물품 상세 내역"
        $0.textColor = .white
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
    }
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    //Basic Info View
    let basicInfoLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 15)
        $0.text = "기본 정보"
        $0.textColor = .lightGray
    }
    let basicTableView = ListTableView(rowHeight: 40, scrollType: .none).then {
        $0.allowsSelection = false
        $0.tableHeaderView = .none
        $0.register(PackageBasicTableViewCell.self, forCellReuseIdentifier: PackageBasicTableViewCell.identifier)
    }
    
    
    //Delivery Info View
    let deliveryInfoLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 15)
        $0.text = "배송 정보"
        $0.textColor = .lightGray
    }
    let deliveryTableView = ListTableView(rowHeight: 40, scrollType: .none).then {
        $0.allowsSelection = false
        $0.tableHeaderView = .none
        $0.register(PackageDeliveryTableViewCell.self, forCellReuseIdentifier: PackageDeliveryTableViewCell.identifier)
    }
    
    //Button
    let completedButton = MainButton(type: .main).then {
        $0.setBackgroundColor(.CjBlue, for: .normal)
        $0.layer.borderColor = UIColor.CjBlue.cgColor
        $0.setTitle("배송완료", for: .normal)
        $0.addTarget(self, action: #selector(deliveryComplete), for: .touchUpInside)
    }
    
    let declinedButton = MainButton(type: .sub).then {
        $0.backgroundColor = .CjYellow
        $0.layer.borderColor = UIColor.CjYellow.cgColor
        $0.setTitle("수취거부", for: .normal)
        $0.addTarget(self, action: #selector(deliveryReject), for: .touchUpInside)

    }
    let missedButton = MainButton(type: .sub).then {
        $0.backgroundColor = .CjRed
        $0.layer.borderColor = UIColor.CjRed.cgColor
        $0.setTitle("미배송", for: .normal)
        $0.addTarget(self, action: #selector(deliveryMiss), for: .touchUpInside)

    }
    
    //셀 내 이미지
    let packageImage = UIImageView().then {
        $0.image = UIImage(named: "selectPhoto")
        $0.cornerRadius = 10
        $0.clipsToBounds = true
    }
    let packageImageTouch = UIButton().then {
        $0.backgroundColor = .clear
        $0.cornerRadius = 10
        $0.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
    }
    let cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "defaultPhoto"), for: .normal)
        $0.cornerRadius = 10
        $0.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
    }
    
    //셀 내 드롭다운
    let dropDownButton1 = UIButton().then {
        $0.setImage(UIImage(named: "btnDown"), for: .normal)
        $0.addTarget(self, action: #selector(showMenu1), for: .touchUpInside)
    }
    let dropDownButton2 = UIButton().then {
        $0.setImage(UIImage(named: "btnDown"), for: .normal)
        $0.addTarget(self, action: #selector(showMenu2), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .CjWhite
        
        navigationController?.navigationBar.isHidden = true
        
        basicTableView.dataSource = self
        basicTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.delegate = self

        
//        view.addSubviews([containerView])
        // -MARK: addSubViews
        self.view.addSubviews([
            navigationView,
            viewScrollContain,
//            basicInfoLabel,
//            basicTableView,
//            deliveryInfoLabel,
//            deliveryTableView,
            missedButton,
            declinedButton,
            completedButton
        ])
        
        navigationView.addSubviews([
            backButton,
            completedLabel
        ])
        
        viewScrollContain.addSubviews([scrollView])
        scrollView.addSubviews([viewContent])
        viewContent.addSubviews([
            basicInfoLabel,basicTableView,
            deliveryInfoLabel,deliveryTableView
        ])
        setConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataManager.getPackageDetail(deliveryPK: deliveryPK!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        basicTableView.snp.updateConstraints { make in
            make.height.equalTo(basicTableView.contentSize.height)
        }
        deliveryTableView.snp.updateConstraints { make in
            make.height.equalTo(deliveryTableView.contentSize.height)
        }
        viewContent.snp.updateConstraints { make in
            make.height.equalTo(basicTableView.frame.height+deliveryTableView.frame.height+170)
        }
    }
    
    func setConstraints( ){
        // ScrollView
        // -MARK: setConstraints
        navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(90)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.bottom.equalTo(navigationView.snp.bottom).offset(-15)
            make.leading.equalToSuperview().offset(24)
        }
        completedLabel.snp.makeConstraints { make in
            make.centerX.equalTo(navigationView.snp.centerX)
            make.bottom.equalTo(navigationView.snp.bottom).offset(-10)
        }
        viewScrollContain.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(completedButton.snp.top).offset(-20)
        }
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        viewContent.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(10000)
        }
//
        missedButton.snp.makeConstraints { make in
            make.centerY.equalTo(declinedButton.snp.centerY)
            make.leading.equalTo(self.view.snp.centerX).offset(5)
//            make.leading.equalTo(self.view).offset(5)
//            make.width.equalTo(100)
            make.trailing.equalTo(self.view).offset(-24)
        }
        declinedButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30)
            make.trailing.equalTo(self.view.snp.centerX).offset(-5)
//            make.width.equalTo(100)
            make.leading.equalTo(self.view).offset(24)
        }
        completedButton.snp.makeConstraints { make in
            make.bottom.equalTo(declinedButton.snp.top).offset(-5)
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
        }
//
        basicInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        basicTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(basicInfoLabel.snp.bottom).offset(10)
//            make.bottom.equalToSuperview()
//            make.height.equalTo(249)
            make.height.equalTo(basicTableView.contentSize.height)
        }
        deliveryInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(basicTableView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
        }
        deliveryTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(deliveryInfoLabel.snp.bottom).offset(10)
//            make.height.equalTo(234)
            make.height.equalTo(deliveryTableView.contentSize.height)
        }
    }
    
    func initDropDown(dropDown: DropDown, anchor: UILabel) {
        dropDown.anchorView = anchor
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            anchor.text = item
            
            if dropDown == dropDown1 {
                receipt = item
            } else {
                recipient = item
            }
            
            //선택한 아이템 초기화
            dropDown.clearSelection()
        }
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectPhoto() {
        print("photo selected")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self //3
        // imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc func showCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.cameraCaptureMode = .photo
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func deliveryComplete() {
        if let str = photoURL, let num = deliveryPK, let receipt = self.receipt, let recipient = self.recipient {
            print(str)
            
            if receipt != "해당 없음", recipient != "해당 없음" {
                dataManager.updateDeliveryInfo(deliveryPK: num, complete: 1, receipt: receipt, recipient: recipient, picture: str)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.presentAlert(title: "누락한 정보가 있습니다.")
            }

        } else {
            self.presentAlert(title: "누락한 정보가 있습니다.")
        }
        
        
    }
    @objc func deliveryReject(){
        if let num = deliveryPK {
            
            dataManager.updateDeliveryInfo(deliveryPK: num, complete: 2, receipt: "", recipient: "", picture: "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func deliveryMiss() {
        if let num = deliveryPK {
            dataManager.updateDeliveryInfo(deliveryPK: num, complete: 4, receipt: "", recipient: "", picture: "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func showMenu1() {
        dropDown1.show()
    }
    @objc func showMenu2() {
        dropDown2.show()
    }
}

extension PackageDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == basicTableView {
            return titles.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == basicTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageBasicTableViewCell.identifier, for: indexPath) as! PackageBasicTableViewCell
    
            cell.titleLabel.text = titles[indexPath.row]
            if let data = packageItemInfo {
                cell.contentLabel.text = contents[indexPath.row]
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDeliveryTableViewCell.identifier, for: indexPath) as! PackageDeliveryTableViewCell
    
            cell.titleLabel.text = deliveryTitles[indexPath.row]
            
            
            if let data = packageItemInfo {
                // 사진 올리기
                if indexPath.row == 4 {

                    cell.contentView.addSubviews([packageImage, packageImageTouch, cameraButton])
                    
                    packageImage.snp.makeConstraints { make in
                        make.centerY.equalToSuperview()
                        make.leading.equalToSuperview().offset(75)
                        make.height.equalTo(60)
                        make.width.equalTo(60)
                    }
                    packageImageTouch.snp.makeConstraints { make in
                        make.edges.equalTo(packageImage)
                    }
                    cameraButton.snp.makeConstraints { make in
                        make.centerY.equalToSuperview()
                        make.leading.equalToSuperview().offset(150)
                        make.height.equalTo(60)
                        make.width.equalTo(60)
                    }
                    
                    if let img = data.picture {
                        if img != "" {
                            packageImage.image = UIImage(named: "택배사진")
                        } else {
                            packageImage.image = UIImage(named: "selectPhoto")
                        }
                        packageImageTouch.isHidden = true
                        cameraButton.isHidden = true
                        
                    } else {
                        packageImageTouch.isHidden = false
                        cameraButton.isHidden = false
                    }
                    
                    
            
                } else if indexPath.row == 0 {
                    if let num = self.complete { //complete 상태 값이 있는 경우
                        if packageItemInfo.complete == 0{
                            cell.contentLabel.text = "미배송"
                            cell.contentLabel.textColor = .CjOrange
                        } else if packageItemInfo.complete == 1 {
                            cell.contentLabel.text = "배송완료"
                            cell.contentLabel.textColor = .CjBlue
                        } else {
                            cell.contentLabel.text = "수취 거부"
                            cell.contentLabel.textColor = .CjRed
                        }
                    } else { // complete 상태 값이 없는 경우
                        cell.contentLabel.text = "배송 전"
                        cell.contentLabel.textColor = .black
                    }
                    
                } else if indexPath.row == 2 {
                    if let num = self.complete {
                        cell.contentLabel.text = deliveryContents[indexPath.row]
                        
                    } else {
                        cell.contentLabel.text = "해당 없음"
                        cell.contentView.addSubview(dropDownButton1)
                        dropDownButton1.snp.makeConstraints { make in
                            make.height.equalTo(20)
                            make.width.equalTo(20)
                            make.centerY.equalToSuperview()
                            make.leading.equalToSuperview().offset(130)
                        }
                        dropDown1.dataSource = ["해당 없음", "직접 전달", "경비실 전달", "문앞 전달", "무인 택배함", "기타"]
                        initDropDown(dropDown: dropDown1, anchor: cell.contentLabel)
                    }
                    
                } else if indexPath.row == 3 {
                    if let num = self.complete {
                        cell.contentLabel.text = deliveryContents[indexPath.row]
                    } else {
                        cell.contentLabel.text = "해당 없음"
                        cell.contentView.addSubview(dropDownButton2)
                        dropDownButton2.snp.makeConstraints { make in
                            make.height.equalTo(20)
                            make.width.equalTo(20)
                            make.centerY.equalToSuperview()
                            make.leading.equalToSuperview().offset(120)
                        }
                        dropDown2.dataSource = ["해당 없음", "본인", "가족", "(직장)동료", "이웃", "기타"]
                        initDropDown(dropDown: dropDown2, anchor: cell.contentLabel)
                    }
                } else {
                    cell.contentLabel.text = deliveryContents[indexPath.row]
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == deliveryTableView {
            if indexPath.row == 4 {
                return 80
            }
        }
        return 40
    }
}

extension PackageDetailViewController: PackageDetailViewControllerDelegate {
    func didSuccessGetPackageDetail(_ result: PackageResponse) {
        packageItemInfo = result
        
        contents.append(Constant.shared.ManId)
        contents.append("123456")
        contents.append(result.itemCategory ?? "")
        contents.append(result.sender ?? "")
        contents.append(result.receiver ?? "")
        contents.append(result.senderAddr ?? "")
        contents.append(result.receiverAddr ?? "")
        contents.append(result.comment ?? "")
        
        
        deliveryContents.append(result.completeTime ?? "")
        deliveryContents.append(result.receipt ?? "")
        deliveryContents.append(result.recipient ?? "")
        deliveryContents.append(result.picture ?? "")
        
        basicTableView.reloadData()
        deliveryTableView.reloadData()
    }
    func failedToRequest(_ message: String) {
        print(message)
    }
    
    func didSuccessUpdatePackageDetail(_ result: PackageResponse) {
        print(result)
    }
    
    func failedToUpadte(_ messgae: String) {
        print(messgae)
    }
}



extension PackageDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택한 이미지 넣기
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            packageImage.contentMode = .scaleToFill
            packageImage.image = pickedImage //4
        }
        
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)

            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            
            self.photoURL = photoURL.absoluteString
            print(self.photoURL)

        }
        
        
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
