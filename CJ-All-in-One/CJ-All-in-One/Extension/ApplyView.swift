//
//  ApplyViewPickerView.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/28.
//

import UIKit
import SnapKit

// -MARK: PickerView
extension ApplyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerTo {
            return 2
        }
        else {
            return 1
        }
    }
    // pickerview의 선택지는 데이터의 개수만큼
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerAvailCount {
            return vehicles.count
        }
        else if pickerView == pickerTo {
            if component==0 {
                return citiesManager.cities.count
            }
            else {
                let selectedCity = pickerTo.selectedRow(inComponent: 0)
                return citiesManager.cities[selectedCity].goos.count
            }
        }
        else {
            return citiesManager.cities.count
        }
    }
    // pickerview 내 선택지의 값들을 원하는 데이터로 채워준다.
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == pickerAvailCount {
//            return vehicles[row]
//        }
//        else if pickerView == pickerTo{
//            if component == 0 {
//                return citiesManager.cities[row].name
//            }
//            else {
//                let selectedCity = pickerTo.selectedRow(inComponent: 0)
//                return citiesManager.cities[selectedCity].goos[row]
//            }
//        }
//        else {
//            return citiesManager.cities[row].name
//        }
//    }
    // textfield의 텍스트에 pickerview에서 선택한 값을 넣어준다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerAvailCount {
            self.textFieldVehicleType.text = self.vehicles[row]
            warningLabel.textColor = .white
        }
        else if pickerView == pickerTo{
            if component == 0 {
                pickerTo.selectRow(0, inComponent: 1, animated: false)
            }

            let cityIdx = pickerTo.selectedRow(inComponent: 0)
            let selectedCity = citiesManager.cities[cityIdx].name
            let gooIdx = pickerTo.selectedRow(inComponent: 1)
            let selectedGoo = citiesManager.cities[cityIdx].goos[gooIdx]
            self.city = selectedCity
            self.goo = selectedGoo
            
            pickerTo.reloadComponent(1)
        }
        else {
            self.receivAddr = citiesManager.cities[row].name
            print(citiesManager.cities[row].name)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowHeight
    }
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: pickerRowHeight))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: pickerRowHeight))
        if pickerView == pickerAvailCount {
            label.text = vehicles[row]
        }
        else if pickerView == pickerFrom {
            label.text = citiesManager.cities[row].name
        }
        if pickerView == pickerTo{
            if component == 0 {
                label.text = citiesManager.cities[row].name
                pickerTo.reloadComponent(1)
            }
            else {
                let selectedCity = pickerTo.selectedRow(inComponent: 0)
                label.text = citiesManager.cities[selectedCity].goos[row]
            }
        }
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80
    }
}

// -MARK: TableView
extension ApplyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToListTableViewCell.identifier, for: indexPath) as! ToListTableViewCell
        cell.rowIndex = indexPath.row
        cell.backgroundColor = .CjWhite
        cell.labelNum.text = "\(indexPath.row+1)"
        cell.labelTo.text = toLists[indexPath.row].city + " " + toLists[indexPath.row].goo
        cell.fontSize = CGFloat(13)
        cell.fontColor = UIColor.tableContentTextColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 && toLists.isEmpty != true {
            toLists.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.reloadData()
            tableView.endUpdates()
            
            tableView.snp.updateConstraints { make in
                if tableTo.rowHeight*CGFloat(toLists.count) < 180 {
                    make.height.equalTo(tableTo.rowHeight*CGFloat(toLists.count))
                }
                else {
                    make.height.equalTo(180)
                    tableTo.isScrollEnabled = true
                }
            }
        }
    }
}
