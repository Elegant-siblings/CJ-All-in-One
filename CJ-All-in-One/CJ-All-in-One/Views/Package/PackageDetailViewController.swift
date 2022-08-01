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

class PackageDetailViewController: UIViewController {
    
    lazy var dataManager: PackageDetailDataManager = PackageDetailDataManager(delegate: self)
    
    // Table 정보
    var packageItemInfo : PackageResponse!
    let tableRowHeight = CGFloat(40)
    let titles = ["배송기사", "송장번호", "상품정보", "보내는 분", "받는 분", "보내는 주소", "받는 주소", "요청 사항"]
    var contents = ["AXSD-SDXD-****-ZS**", "1233567"]
    let deliveryTitles = ["배송현황", "배송 완료 시각", "수취 방법", "수령인", "사진"]
    var deliveryContents : [String] = [""]
    var deliveryImgStr : String?
    var deliveryPK : Int?
    var photoURL : String?
    
    // UIScrollView 정의
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .deppBlue
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    let scrollContentView = UIView().then {
        $0.backgroundColor = .white
    }
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
        $0.layer.addShadow(location: [.top, .bottom])
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
        $0.layer.addShadow(location: [.top, .bottom])
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        basicTableView.dataSource = self
        basicTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.delegate = self

        
//        view.addSubviews([containerView])
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        self.scrollContentView.addSubviews([navigationView, basicInfoLabel, basicTableView, deliveryInfoLabel, deliveryTableView, missedButton, declinedButton, completedButton])
        navigationView.addSubviews([backButton, completedLabel])
        
        
        setConstraints()
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        basicTableView.snp.makeConstraints { make in
            make.height.equalTo(basicTableView.contentSize.height)
        }
        deliveryTableView.snp.makeConstraints { make in
            make.height.equalTo(basicTableView.contentSize.height)
        }
        
        
        dataManager.getPackageDetail(deliveryPK: deliveryPK!)
    }
    
    
//    private func presentCircleView() {
//        let width = self.containerView.frame.width / 2
//        let height = self.containerView.frame.height / 2
//
//        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
////        pieChartView.center = self.view.center
//
//        pieChartView.slices = [Slice(percent: 0.75, color: UIColor.systemOrange),
//                                Slice(percent: 0.1, color: UIColor.systemTeal),
//                                Slice(percent: 0.15, color: UIColor.systemRed)]
//
//        containerView.addSubview(pieChartView)
//        pieChartView.animateChart()
//    }
    
    func setConstraints( ){
        // ScrollView
        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom)
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(1200)
        }
        
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
        
        basicInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(20)
            make.leading.equalTo(self.view).offset(24)
        }
        basicTableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.top.equalTo(basicInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(249)
        }
        deliveryInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(basicTableView.snp.bottom).offset(30)
            make.leading.equalTo(self.view).offset(24)
        }
        deliveryTableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.top.equalTo(deliveryInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(234)
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
        if let str = photoURL, let num = deliveryPK {
            print(str)
            
            dataManager.updateDeliveryInfo(deliveryPK: num, complete: 1, receipt: "haha", recipient: "hoho", picture: str)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.presentAlert(title: "사진을 첨부해 주세요.")
        }
        
        
    }
    @objc func deliveryReject(){
        if let num = deliveryPK {
            
            dataManager.updateDeliveryInfo(deliveryPK: num, complete: 2, receipt: "haha", recipient: "hoho", picture: "")
            self.navigationController?.popViewController(animated: true)

        } else {
            self.presentAlert(title: "사진을 첨부해 주세요.")
        }

    }
    @objc func deliveryMiss() {
        if let num = deliveryPK {
            dataManager.updateDeliveryInfo(deliveryPK: num, complete: 4, receipt: "haha", recipient: "hoho", picture: "")
            self.navigationController?.popViewController(animated: true)

        } else {
            self.presentAlert(title: "사진을 첨부해 주세요.")

        }

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
                        packageImage.image = UIImage(named: "택배사진")
                        cameraButton.isHidden = true
                        
                    } else {
                        
                        cameraButton.isHidden = false
                    }
            
                } else if indexPath.row == 0 {
                    
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
        
        contents.append(result.itemCategory ?? "")
        contents.append(result.sender ?? "")
        contents.append(result.receiver ?? "")
        contents.append(result.senderAddr ?? "")
        contents.append(result.receiverAddr ?? "")
        contents.append(result.comment ?? "")
        
        
        deliveryContents.append(result.completeTime ?? "")
        deliveryContents.append("대면 배달")
        deliveryContents.append("본인")
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
