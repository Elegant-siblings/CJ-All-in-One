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
    let detailTypes = ["모집내역", "배송내역"]
    let taskDataManager = TaskDataManager()
    var taskList:[Task] = []
    var allTasks: [Task] = []
    var completedTasks:[Task] = []
    var whatTask : Task?
    
    let worksDetailDataManager: MainWorkDetailDataManager = MainWorkDetailDataManager()
    
    // -MARK: UIViews
    lazy var navBar = CustomNavigationBar().then {
        $0.backgroundColor = .deppBlue
    }
    
    lazy var viewTableContainer = UIView().then{
        $0.backgroundColor = .red
    }
    
    lazy var viewApplyButtonContainer = UIView().then{
        $0.backgroundColor = .CjWhite
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
    }
    
    lazy var distributeBar = UIView().then{
        $0.backgroundColor = UIColor(rgb: 0xB4B4B4)
    }
    
    lazy var imageLogo = UIImageView(image: UIImage(named: "CJ_logo_bar")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    // -MARK: UIButtons
    lazy var buttonApply = MainButton(type: .main).then{
        $0.setTitle("모집 신청하기", for: .normal)
        $0.addTarget(self, action: #selector(touchUpApplyButton), for: .touchUpInside)
    }
    
    lazy var buttonSort = UIButton().then{
        $0.backgroundColor = .CjWhite
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor(rgb: 0x8B8B8B).cgColor
        $0.layer.borderWidth = 0.5
        let customButtonLabel = NSMutableAttributedString(
            string: " 정렬",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x8B8B8B),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10,weight: .bold)
            ])
        $0.setAttributedTitle(customButtonLabel, for: .normal)
        $0.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        $0.tintColor = UIColor(rgb: 0x8B8B8B)
    }
    
    lazy var logOutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.tintColor = .CjWhite
        $0.titleLabel!.font = UIFont.AppleSDGothicNeo(.bold, size: 14)
        $0.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }

    // -MARK: Others
    lazy var tableAssignedTask = UITableView().then{
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(DeliveryDetailTableViewCell.self, forCellReuseIdentifier: DeliveryDetailTableViewCell.identifier)
        $0.rowHeight = 100
        $0.backgroundColor = .CjWhite
        $0.refreshControl = UIRefreshControl()
        $0.refreshControl?.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
    }
    
    lazy var tableCompleteTask = UITableView().then{
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(DeliveryDetailTableViewCell.self, forCellReuseIdentifier: DeliveryDetailTableViewCell.identifier)
        $0.rowHeight = 100
        $0.backgroundColor = .CjWhite
        $0.refreshControl = UIRefreshControl()
        $0.refreshControl?.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
    }
    
    let vcAssigned = UIViewController().then {
        $0.view.backgroundColor = .CjWhite
    }
    let vcComplete = UIViewController().then {
        $0.view.backgroundColor = .CjBlue
    }
    
    var dataViewControllers: [UIViewController] {
        [vcAssigned,vcComplete]
    }
    
    var currentPage: Int = 0 {
        didSet {
          // from segmentedControl -> pageViewController 업데이트
          let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
          self.pageViewController.setViewControllers(
            [dataViewControllers[self.currentPage]],
            direction: direction,
            animated: true,
            completion: nil
          )
        }
      }
    
    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
        $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        $0.dataSource = self
        $0.view.backgroundColor = .CjWhite
        $0.delegate = self
    }
    
    lazy var SCDetailType = UISegmentedControl(items: detailTypes).then{
        $0.backgroundColor = .CjWhite
        $0.layer.cornerRadius = 3
        $0.selectedSegmentTintColor = .CjRed
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.CjRed, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .selected)
        let backgroundImage = UIImage()
        let colorView = UIView()
        colorView.backgroundColor = .CjRed
        $0.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)

        $0.selectedSegmentIndex = 0
        $0.apportionsSegmentWidthsByContent = false
        $0.addTarget(self, action: #selector(detailTypeChanged(type:)), for: UIControl.Event.valueChanged)
    }
    
    // -MARK: selectors
    @objc
    func detailTypeChanged(type: UISegmentedControl) {
        self.currentPage = type.selectedSegmentIndex
    }
    
    @objc func touchUpApplyButton() {
        print("모집 신청하기")
        let vc = ApplyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refreshTable(_ sender: UIRefreshControl) {
        taskDataManager.getTasks(self, id: ManId)
        sender.endRefreshing()
    }
    @objc func logOut() {
        print("로그 아웃")
        ManId = ""
        Constant.shared.account = ""
        
        let vc = SignInViewController()
        self.dismiss(animated: true)
        self.present(vc, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskDataManager.getTasks(self, id: ManId)
        tableAssignedTask.reloadData()
    }

    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .CjWhite
        
        handleNotAuthenticated()
        
        taskDataManager.getTasks(self, id: ManId)
        
        self.view.addSubviews([
            navBar,
            SCDetailType,
            buttonSort,
            distributeBar,
            viewTableContainer,
            viewApplyButtonContainer,
            buttonApply
        ])
        navBar.addSubviews([imageLogo, logOutButton])
        self.viewTableContainer.addSubviews([
            pageViewController.view,
        ])
        vcComplete.view.addSubviews([tableCompleteTask])
        vcAssigned.view.addSubviews([tableAssignedTask])
        
        setConstraints()
        detailTypeChanged(type: self.SCDetailType)
        
    }
    
    // -MARK: makeConstraints
    private func setConstraints() {
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-3)
        }
        logOutButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(imageLogo.snp.centerY)
        }
        SCDetailType.snp.makeConstraints { make in
            make.leading.equalTo(21)
            make.top.equalTo(navBar.snp.bottom).offset(10)
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
            make.top.equalTo(SCDetailType.snp.bottom).offset(8)
            make.leading.equalTo(21)
            make.height.equalTo(1)
            make.width.equalTo(345)
        }
        
        viewTableContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(141)
            make.width.equalToSuperview()
            make.bottom.equalTo(viewApplyButtonContainer.snp.top)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        viewApplyButtonContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(116)
            make.bottom.equalToSuperview()
        }
        buttonApply.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.top).offset(mainButtonTopOffset)
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
        }
        tableAssignedTask.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        tableCompleteTask.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    func successGetTasks(result: [Task]) {
        completedTasks.removeAll()
        taskList.removeAll()
        for task in result {
            if task.workState == 2 {
                completedTasks.append(task)
            }
            else {
                taskList.append(task)
            }
        }
        tableAssignedTask.reloadData()
        tableCompleteTask.reloadData()
    }
    
    func didSuccessGetCompletedDetail(_ result: DeliveryCompletedResponse) {
        
        if let task = whatTask {
            let vc = FindPathViewController()
            vc.terminalAddr = task.terminalAddr
            vc.workPK = task.workPK
            var deliveryPK : [Int] = []
            for i in result.itemList {
                deliveryPK.append(i.deliveryPK)
            }
            vc.deliveryPK = deliveryPK
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func failedToRequest(message: String) {
        print(message)
    }
    
    private func handleNotAuthenticated() {
        // Check auth status
        if ManId == "" {
            // show log in
            let loginVC = SignInViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }

    }
    
}

// -MARK: TableView Extension
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView==tableAssignedTask ? taskList.count : completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailTableViewCell.identifier, for: indexPath) as! DeliveryDetailTableViewCell
        let background = UIView().then{
            $0.backgroundColor = .clear
        }
        cell.detailDelegate = self
        cell.task = tableView==tableAssignedTask
                                ? taskList[indexPath.row]
                                : completedTasks[indexPath.row]
        cell.selectedBackgroundView = background
        cell.backgroundColor = .CjWhite
        return cell
    }
}

// -MARK: CellDelegate Extension
extension MainViewController: DetailDelegate {
    func getIngDetail(whatTask: Task) {
        // 배송중인 화면
        self.whatTask = whatTask
        worksDetailDataManager.getDeliveryCompletedDetail(whatTask.workPK, self)
        
    }
    
    func getTaskDetail(whatTask: Task) {
        let vc = WorkViewController()
        vc.task = whatTask
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCompleteDetail(whatTask: Task) {
        print("배송완료상세내역")
        //whatTask 넘겨줘야 함
        let vc = DeliveryCompletedViewController()
        vc.workPK = whatTask.workPK
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// -MARK: PageView Extension
extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index + 1 < self.dataViewControllers.count else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0], let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        self.currentPage = index
        self.SCDetailType.selectedSegmentIndex = index
    }
}
