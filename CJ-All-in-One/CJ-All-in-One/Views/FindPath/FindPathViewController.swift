//
//  ViewController.swift
//  CJ-NaverAPI-Example
//
//  Created by 최원준 on 2022/07/04.
//

import UIKit
import CoreLocation
import NMapsMap
import SnapKit
import Then
import PanModal

// MARK: - init 시 필요한 값: 1. 출발/목적지 위/경도 값 2. 경유지 포인트 위/경도 값(array)

class FindPathViewController: UIViewController {
    
    var distance: String!
    var time: String!
    
    
    let bottomSheetVC = FindPathBottomViewController()
    
    private let locationManager = NMFLocationManager.sharedInstance()
    
    var longitude: CLLocationDegrees!
    var latitude: CLLocationDegrees!

    //출발 & 도착 위치 정보: southWest -> 출발, nortEast -> 도착
//    let departLocation = NMGLatLng(lat: 37.7014553, lng: 126.7644840)
//    let destLocation = NMGLatLng(lat: 37.4282975, lng: 127.1837949)
    var totalPoints = [NMGLatLng]()
    var totalPointsNum : Int!
    var firstOne: Bool = true
    var onGoing: Bool = false
    var bounds1 : NMGLatLngBounds!
    
    var boundsArray = [NMGLatLngBounds]()
    var boundsIdx = 0
    
    // 경유지 정보
    var wayPoitns = [NMGLatLng]()
    
    var wayPointsForBounds = [NMGLatLng]()
    var wayPointsToString : String = ""
    var wayPointNames : [String] = []

    
    //경로
    var progressPathOverlay: NMFPath?
    var progressMultipartPath: NMFMultipartPath?
    var coords = [NMGLatLng]()
    var stringCoords = [NMGLineString<NMGLatLng>]()
    var wayPointIdx : [Int] = []
    
    lazy var dataManager = MapDataManager(delegate: self)

    
    let mapView = NMFMapView().then{
        $0.allowsZooming = true
        $0.layer.addShadow(location: [.bottom])
    }
    
    //    init(dep_lng: Double, dep_lat: Double, dest_lng: Double, dest_lat: Double) {
    //        self.bounds1.southWestLng = dep_lng
    //        self.bounds1.southWestLat = dep_lat
    //        self.bounds1.northEastLng = dest_lng
    //        self.bounds1.northEastLat= dest_lat
    //    }
    
    var mapImage = UIImage()
    
    
    let pathButton = UIButton().then {
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 30
        $0.layer.borderColor = UIColor.CjBlue.cgColor
        $0.setImage(UIImage(systemName: "shippingbox"), for: .normal)
        $0.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.tintColor = .CjWhite
    }
    let zoomWayButton = UIButton().then {
        $0.backgroundColor = .CjYellow
        $0.layer.cornerRadius = 30
        $0.layer.borderColor = UIColor.CjYellow.cgColor
        $0.setImage(UIImage(systemName: "location.magnifyingglass"), for: .normal)
        $0.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.tintColor = .CjWhite
    }
    
    let distanceLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "km"
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 13)
    }
    
    let timeLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "시간"
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 13)
    }
    let timeAssumptionLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "도착 예정"
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 13)
    }
    
    let infoView = UIView().then  {
        $0.backgroundColor = .white
        $0.alpha = 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
//        dataManager.dockerExample()
        
        navigationController?.navigationBar.isHidden = true
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        
        pathButton.addTarget(self, action: #selector(showTable), for: .touchUpInside)
        zoomWayButton.addTarget(self, action: #selector(serialPath), for: .touchUpInside)
        
        view.addSubviews([mapView, pathButton, zoomWayButton])
        mapView.addSubviews([infoView])
        infoView.addSubviews([distanceLabel, timeLabel, timeAssumptionLabel])
        
//        self.view.bringSubviewToFront(buttonView)
//        self.mapView.bringSubviewToFront(pathButton)
//        self.mapView.bringSubviewToFront(zoomWayButton)
        
        //위치 표시하기
        locationManager!.add(self)
        self.mapView.positionMode = .direction
        
        // 내 위치로 카메라 이동하는거 ㄹㅇ 못 해먹곘어 씨발
//        if let location = locationManager?.currentLatLng() {
//            let camUpdate = NMFCameraUpdate(position: NMFCameraPosition(location), zoom: 16)
//            camUpdate.animation = .fly
//            camUpdate.animationDuration = 1
//            mapView.moveCamera(camUpdate)
//        } else {
//            print("현재 위치를 표시 못 함")
//        }
//

        //경로 찾기 함수 실행
//        pathButton.addTarget(self, action: #selector(serialPath), for: .touchUpInside)
        setConstraints()
        
        dataManager.getLocation()
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //path 설정
//        configurePath()
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //뷰 벗어날 때 위치 받기 해제
        locationManager?.remove(self)
        print(locationManager?.currentLatLng())
    }
    
    func setConstraints() {

        mapView.snp.makeConstraints { make in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-150)
            make.top.equalTo(self.view)
        }
        infoView.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.leading).offset(20)
            make.trailing.equalTo(mapView.snp.trailing).offset(-20)
            make.height.equalTo(31)
            make.bottom.equalTo(mapView.snp.bottom).offset(-60)
        }
        // UIButton
        pathButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.trailing.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view).offset(-40)
        }
        zoomWayButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.trailing.equalTo(pathButton.snp.leading).offset(-20)
            make.bottom.equalTo(self.view).offset(-40)
        }
        
        // UILabel
        timeAssumptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoView.snp.centerY)
            make.leading.equalTo(infoView.snp.leading).offset(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoView.snp.centerY)
            make.centerX.equalTo(infoView.snp.centerX)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoView.snp.centerY)
            make.trailing.equalTo(infoView.snp.trailing).offset(-20)
        }
    }

    
    func initPath() {
        let width: CGFloat = 8
        let outlineWidth: CGFloat = 2
        
        if wayPoitns.count == 0 {
            //단일 경로 찍기
            if let pathOverlay = NMFPath(points: coords) {
                pathOverlay.width = width
                pathOverlay.outlineWidth = outlineWidth
                pathOverlay.color = .systemPink
                pathOverlay.outlineColor = UIColor.white
//                pathOverlay.passedColor = UIColor.gray
//                pathOverlay.passedOutlineColor = UIColor.white
//                pathOverlay.progress = 0.3
                pathOverlay.mapView = mapView
                progressPathOverlay = pathOverlay
            }
        } else {
            // 경유지 포함 경로 찍기(색깔 다르게)
            if let lineString = self.stringCoords as? [NMGLineString<AnyObject>], let multipartPathOverlay = NMFMultipartPath(lineString) {
                multipartPathOverlay.colorParts = MultiPartData.colors1
                multipartPathOverlay.width = width
                multipartPathOverlay.outlineWidth = outlineWidth
                multipartPathOverlay.mapView = mapView
                progressMultipartPath = multipartPathOverlay
            }
        }
    }
    
    func configurePath() {
        wayPointIdx.removeAll()
        coords.removeAll()
        stringCoords.removeAll()
        
        self.showIndicator()
        
        //경유지 쿼리 스트링 일부 만들기
        if totalPoints.count < 8 {
            if totalPoints.count > 2 { //경유지가 존재할 경우
                for i in 1..<totalPoints.count - 1 {
                    wayPointsToString += "\(totalPoints[i].lng),\(totalPoints[i].lat)|"
                }
                wayPointsToString = String(wayPointsToString.dropLast())
                
                print(wayPointsToString)
            }
            onGoing = false

            print(totalPoints.endIndex)
            
            dataManager.shortestPath(depLng: totalPoints[0].lng, depLat: totalPoints[0].lat, destLng: totalPoints[totalPoints.endIndex - 1].lng, destLat: totalPoints[totalPoints.endIndex - 1].lat, wayPoints: wayPointsToString ?? nil, option: "trafast")
           
            
            
        } else {
            // 6개 이상이면 5번째까지만 받는다
            for i in totalPoints[1..<6] {
                wayPointsToString += "\(i.lng),\(i.lat)|"
            }
            wayPointsToString = String(wayPointsToString.dropLast())
            
            print(wayPointsToString)
            onGoing = true
            
            dataManager.shortestPath(depLng: totalPoints[0].lng, depLat: totalPoints[0].lat, destLng: totalPoints[6].lng, destLat: totalPoints[6].lat, wayPoints: wayPointsToString ?? nil, option: "trafast")
        }
    }
    
    func setMarker() {
        // 출발지 & 도착지 위치 마커 찍기
        let departMark = NMFMarker(position: bounds1.southWest)
        departMark.mapView = mapView
        departMark.iconImage = NMF_MARKER_IMAGE_BLACK
        departMark.captionTextSize = 20
        departMark.captionAligns = [NMFAlignType.top]
        departMark.captionText = "출발지"
        let destMark = NMFMarker(position: bounds1.northEast)
        destMark.mapView = mapView
        destMark.iconImage = NMF_MARKER_IMAGE_BLACK
        destMark.captionTextSize = 20
        destMark.captionAligns = [NMFAlignType.top]
        destMark.captionText = "목적지"
    
        // 경유지 마커 찍기
        var markList = [NMFMarker]()
        let markImages = [NMF_MARKER_IMAGE_RED, NMF_MARKER_IMAGE_YELLOW, NMF_MARKER_IMAGE_PINK, NMF_MARKER_IMAGE_GREEN, NMF_MARKER_IMAGE_BLUE ]
        for i in 0..<wayPoitns.count{
            let mark = NMFMarker(position: NMGLatLng(lat: wayPoitns[i].lat, lng: wayPoitns[i].lng))
            mark.iconImage = markImages[i % 5]
            mark.captionTextSize = 20
            mark.captionAligns = [NMFAlignType.top]
            mark.captionText = wayPointNames[i]
            mark.mapView = mapView
            markList.append(mark)
        }
    
//        let way1Mark = NMFMarker(position: NMGLatLng(lat: self.wayPoitns[0].lat, lng: self.wayPoitns[0].lng))
//        way1Mark.iconImage = NMF_MARKER_IMAGE_RED
//        way1Mark.captionTextSize = 20
//        way1Mark.captionAligns = [NMFAlignType.top]
//        way1Mark.captionText = wayPointNames[0]
//        way1Mark.mapView = mapView
//        let way2Mark = NMFMarker(position: NMGLatLng(lat: self.wayPoitns[1].lat, lng: self.wayPoitns[1].lng))
//        way2Mark.iconImage = NMF_MARKER_IMAGE_YELLOW
//        way2Mark.captionTextSize = 20
//        way2Mark.captionAligns = [NMFAlignType.top]
//        way2Mark.captionText = wayPointNames[1]
//        way2Mark.mapView = mapView
        
    }
    
    
    
    @objc func serialPath() {
        print("zoom")
        if boundsIdx == boundsArray.count {
            boundsIdx = 0
        }
        
        let camUpdate = NMFCameraUpdate(fit: boundsArray[boundsIdx], padding: 40)
        camUpdate.animation = .fly
        camUpdate.animationDuration = 1
        mapView.moveCamera(camUpdate)
        
        boundsIdx += 1
    }
    
    @objc func showTable() {
        print("show")
        bottomSheetVC.distance = distance
        bottomSheetVC.time = time
        bottomSheetVC.delegate = self
        bottomSheetVC.tableDelegate = self
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        self.presentPanModal(bottomSheetVC)
    }
}

extension FindPathViewController: ViewDelegate {
    func pushed() {
        let nextVC = DeliveryCompletedViewController()
        nextVC.mapView.image = mapImage
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension FindPathViewController: TableViewDelegate {
    func cellTouched() {
        let nextVC = PackageDetailViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}


extension FindPathViewController: NMFLocationManagerDelegate {
}

extension FindPathViewController: FindPathViewControllerDelegate{
    func didSuccessReceivedLngLat(_ result: LocationResponse) {
        
        totalPoints.append(NMGLatLng(lat: Double(result.start[0]) ?? 0, lng: Double(result.start[1]) ?? 0))
        for i in result.waypoint {
            totalPoints.append(NMGLatLng(lat: Double(i[0]) ?? 0, lng: Double(i[1]) ?? 0))
        }
        totalPoints.append(NMGLatLng(lat: Double(result.finish[0]) ?? 0, lng: Double(result.finish[1]) ?? 0))
        totalPointsNum = totalPoints.count
        
        //출발지 & 목적지 위/경도 저장
        bounds1 = NMGLatLngBounds(southWest: NMGLatLng(lat: totalPoints[0].lat, lng: totalPoints[0].lng), northEast: NMGLatLng(lat: totalPoints.last!.lat, lng: totalPoints.last!.lng))
        
        print(bounds1)
        
        
        for i in 0..<result.waypoint.count{
            wayPoitns.append(NMGLatLng(lat: Double(result.waypoint[i][0]) ?? 0, lng: Double(result.waypoint[i][1]) ?? 0))
            wayPointNames.append("경유지\(i+1)")
        }
        
        print(wayPoitns)
        
        //출발지부터 목적지까지 전부 bound array에 넣기
        for i in 1..<totalPoints.count {
            boundsArray.append(NMGLatLngBounds(southWest: totalPoints[i-1], northEast: totalPoints[i]))
        }
        print(boundsArray)
        
        configurePath()
        
        //재귀랑 전혀 상관 없음
        setMarker()
        
    }
    
    func didSuccessReturnPath(result: Trafast){
        
//        if onGoing {
//
//        } else {
//
//        }
        
        // 경유지 인덱스 반환
        for i in result.guide {
            if i.instructions == "경유지" {
                wayPointIdx.append(i.pointIndex)
            }
        }
        
        for i in 0..<result.path.count {
            coords.append(NMGLatLng(lat: result.path[i][1], lng: result.path[i][0]))
            
            for s in wayPointIdx {
                if i == s {
                    print("경유지")
                    stringCoords.append(NMGLineString(points: coords))
                    coords.removeAll()
                    break
                }
            }
        }
        stringCoords.append(NMGLineString(points: coords)) // 마지막까지의 경로
        
        
//        CoordsData.coords = CoordsData.coords.dropFirst()
        
        // Path 그리기
        initPath()
        
        
        // 처음 불러 올때만 실행
        if firstOne {
            distance = "\(result.summary.distance / 1000)km"
            distanceLabel.text = distance
            
            
            let milliseconds = result.summary.duration
            let hours = ((milliseconds / (1000*60*60)) % 24)
            let mins = ((milliseconds / (1000*60)) % 60)
            time = "\(hours)시간 \(mins)분"
            timeLabel.text = time
            
            let date = Date()
    //        let dateHour = Calendar.current.date(byAdding: .hour, value: hours, to: date)
    //        let dateMin = Calendar.current.date(byAdding: .minute, value: mins, to: dateHour)
            
            
            let camUpdate = NMFCameraUpdate(fit: bounds1, padding: 40)
            camUpdate.animation = .fly
            camUpdate.animationDuration = 1
            mapView.moveCamera(camUpdate)
            
            mapImage = mapView.asImage()
            
            firstOne = false
        }
        
        if !onGoing {
            wayPointsToString = ""
            totalPoints = totalPoints.dropLast()
            
            self.dismissIndicator()
            return
        } else {
            wayPointsToString = ""
            totalPoints.removeSubrange(0..<6)
            
            configurePath()
        }
    }
    
    
    func failedToRequest(message: String){
        print(message)
    }
}




struct MultiPartData {
    //경유지 최대 5개이므로 색상 6개 설정
    static let colors1: [NMFPathColor] = [
        NMFPathColor(color: UIColor.pathRed, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.white),
        NMFPathColor(color: UIColor.pathYellow, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.white),
        NMFPathColor(color: UIColor.pathPink, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.white),
        NMFPathColor(color: UIColor.pathGreen, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.white),
        NMFPathColor(color: UIColor.pathBlue, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.white),
        NMFPathColor(color: UIColor.pathBlack, outlineColor: UIColor.white, passedColor: UIColor.gray, passedOutlineColor: UIColor.white)
    ]
}
