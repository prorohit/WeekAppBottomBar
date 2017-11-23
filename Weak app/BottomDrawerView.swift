//
//  BottomDrawerView.swift
//  Weak app
//
//  Created by Rohit Singh on 11/22/17.
//  Copyright © 2017 Rohit Singh. All rights reserved.
//

import UIKit

class BottomDrawerView: UIView {
    
    @IBOutlet weak var collectionViewWeeksFilter: UICollectionView!
    @IBOutlet weak var collectionViewWeeks: UICollectionView!
    
    var startDateForWeeks = Date()

    let range = "range", values = "values"
    var rangeLimit = 1
    
    // Bottom weeks Selection Type
    let arrOfWeekName = ["Today","1 Week","2 Weeks","1 Month","3 Months"]
    var arrOfSelectedWeekName = [IndexPath]()
    
    var arrOfWeekFilter = [Dictionary<String, Any>]()
    var arrOfSelectedWeekFilter = [IndexPath]()

    
    
    let colorBackgroundBlue = UIColor(red: 83 / 255.0, green: 144 / 255.0, blue: 257 / 255.0, alpha: 1)
    
    let cellIdentifier = "cellWeeks"
    
    var globalClosure = {(_ value: Bool) -> Void in }
    
    func sendCallBackOnButtonClick(_ completion : @escaping (Bool) -> Void) {
        self.globalClosure = completion
    }
    
    override func awakeFromNib() {
        self.configuration()
    }
    
    
    class func loadView () -> UIView {
        let view = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)![0] as! UIView
        return view
    }
    
     func configuration() {
        self.collectionViewWeeks.register(UINib(nibName:"CollectionViewWeeksCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.collectionViewWeeks.delegate = self
        self.collectionViewWeeks.dataSource = self
        
        self.collectionViewWeeksFilter.register(UINib(nibName:"CollectionViewWeeksCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.collectionViewWeeksFilter.delegate = self
        self.collectionViewWeeksFilter.dataSource = self
        
        self.startDateForWeeks = self.getStartingDate()
        
    }
    
    @IBAction func tapArrowButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.globalClosure(sender.isSelected)
        
    }
    
    //MARK: Private Methods
    
    // Getting weeks for the 7 days and 14 days period
    func getDatesAlongWithRange(forLastNDays nDays: Int, previousDates: Bool) -> [Dictionary<String, Any>] {
        var arrCompleteArray = [Dictionary<String, Any>]()
        let cal = NSCalendar.current
        // start with today
        var date = startDateForWeeks
        
        
        var arrDates = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"

        let dateFormatterRangeValues = DateFormatter()
        dateFormatterRangeValues.dateFormat = "dd-MM-yyyy"

        arrDates.append(dateFormatter.string(from: date))
        
        var arrOfRangeOfDates = [String]()
        var rangeString = ""


        for totalCount in 0 ... nDays {
            // move back in time by one day:
            
            let val = previousDates ? -1 : 1;
            
            date = cal.date(byAdding: Calendar.Component.day, value: val, to: date)!
            
            var dict = Dictionary<String, Any>()
            
            let dateStringRange = dateFormatterRangeValues.string(from: date)
            arrOfRangeOfDates.append(dateStringRange)
            
            if totalCount % rangeLimit == 0 {
                rangeString = ""
                let dateString = dateFormatter.string(from: date)
                rangeString = dateString
            } else if totalCount % rangeLimit == rangeLimit - 1 {
                    let dateString = dateFormatter.string(from: date)
                    rangeString = rangeString + " - " + dateString
                
                dict[self.range] = rangeString
                dict[self.values] = arrOfRangeOfDates
                arrCompleteArray.append(dict)
                arrOfRangeOfDates.removeAll()
            }
            
           
            
        }
        return arrCompleteArray
    }
    
    // Getting 1 month  data
    
    func getOneMonthData(forLastNDays nDays: Int, previousDates: Bool) -> [Dictionary<String, Any>]{
        var arrCompleteArray = [Dictionary<String, Any>]()
        let cal = NSCalendar.current
        // start with today
        var date = startDateForWeeks
        
        var arrMonths = [String]()
        
        let dateFormatterRangeValues = DateFormatter()
        dateFormatterRangeValues.dateFormat = "dd-MM-yyyy"
        
        var arrOfRangeOfDates = [String]()
        
        for _ in 0 ... nDays {
            // move back in time by one day:
            let val = previousDates ? -1 : 1;
            date = cal.date(byAdding: Calendar.Component.day, value: val, to: date)!
            
            let dateStringRange = dateFormatterRangeValues.string(from: date)
            arrOfRangeOfDates.append(dateStringRange)

            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            let nameOfMonth = dateFormatter.string(from: date)
            
            if arrMonths.contains(nameOfMonth) == false {
                arrMonths.append(nameOfMonth)
            }
        }
        
        var dict = Dictionary<String, Any>()

        for month in arrMonths {
            var arrOfAllDates = [String]()

            for dateStringInArray in arrOfRangeOfDates {
                let dateFromArrayString = dateFormatterRangeValues.date(from: dateStringInArray)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                let monthFromDateOfStringOfArray = dateFormatter.string(from: dateFromArrayString!)
                
                if month == monthFromDateOfStringOfArray {
                    arrOfAllDates.append(dateStringInArray)
                }
                
            }
            
            dict[self.range] = month
            dict[self.values] = arrOfAllDates
            arrCompleteArray.append(dict)
            
        }
        
        return arrCompleteArray

    }
    
    // Getting 3 months Data

    func getThreeMonthData(forLastNDays nDays: Int, previousDates: Bool) -> [Dictionary<String, Any>]{
        var arrCompleteArray = [Dictionary<String, Any>]()
        var arrFinalCompletedArray = [Dictionary<String, Any>]()

        let cal = NSCalendar.current
        // start with today
        var date = startDateForWeeks
        
        var arrMonths = [String]()
        
        let dateFormatterRangeValues = DateFormatter()
        dateFormatterRangeValues.dateFormat = "dd-MM-yyyy"
        
        var arrOfRangeOfDates = [String]()
        
        for _ in 0 ... nDays {
            // move back in time by one day:
            let val = previousDates ? -1 : 1;
            date = cal.date(byAdding: Calendar.Component.day, value: val, to: date)!
            
            let dateStringRange = dateFormatterRangeValues.string(from: date)
            arrOfRangeOfDates.append(dateStringRange)
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            let nameOfMonth = dateFormatter.string(from: date)
            
            if arrMonths.contains(nameOfMonth) == false {
                arrMonths.append(nameOfMonth)
            }
        }
        
        var dict = Dictionary<String, Any>()
        
        for month in arrMonths {
            var arrOfAllDates = [String]()
            
            for dateStringInArray in arrOfRangeOfDates {
                let dateFromArrayString = dateFormatterRangeValues.date(from: dateStringInArray)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                let monthFromDateOfStringOfArray = dateFormatter.string(from: dateFromArrayString!)
                
                if month == monthFromDateOfStringOfArray {
                    arrOfAllDates.append(dateStringInArray)
                }
                
            }
            
            dict[self.range] = month
            dict[self.values] = arrOfAllDates
            arrCompleteArray.append(dict)
            
        }
        
        var monthCount = 0;
        var monthRange = ""
        var arrOfAllCombinedDates = [String]()
        for obj in arrCompleteArray {
            
            arrOfAllCombinedDates.append(contentsOf: obj[self.values] as! [String])

            monthCount = monthCount + 1
            if monthCount % 3 == 1 {
                monthRange = obj[self.range] as! String
            }
            else if monthCount % 3 == 0 {
                monthCount = 0
                monthRange = monthRange + " - " + (obj[self.range] as! String)
                
                var dict = Dictionary<String, Any>()
                dict[self.range] = monthRange
                dict[self.values] = arrOfAllCombinedDates

                arrFinalCompletedArray.append(dict)
                arrOfAllCombinedDates.removeAll()
                monthRange = ""
            }
        }
        
        
        
        return arrFinalCompletedArray
        
    }

    
    func getStartingDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = "31-12-2016"
        return dateFormatter.date(from: strDate)!
    }
    
}

extension BottomDrawerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewWeeksFilter {
            return self.arrOfWeekFilter.count
        } else {
            return self.arrOfWeekName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewWeeksCell

        if collectionView == self.collectionViewWeeks {
                cell.lblWeekName.text = self.arrOfWeekName[indexPath.item]
                if self.arrOfSelectedWeekName.contains(indexPath) {
                    cell.lblWeekName.layer.cornerRadius = 15.0
                    cell.lblWeekName.clipsToBounds  = true
                    cell.lblWeekName.backgroundColor = self.colorBackgroundBlue
                    cell.lblWeekName.textColor = UIColor.white
                } else {
                    cell.lblWeekName.backgroundColor = UIColor.white
                    cell.lblWeekName.textColor = self.colorBackgroundBlue
                }
            
            
        } else {
            cell.lblWeekName.text = self.arrOfWeekFilter[indexPath.item][self.range] as? String
            cell.lblWeekName.font = UIFont(name: "Helvetica", size: 14.0)
            if self.arrOfSelectedWeekFilter.contains(indexPath) {
                cell.lblWeekName.layer.cornerRadius = 15.0
                cell.lblWeekName.clipsToBounds  = true
                cell.lblWeekName.backgroundColor = self.colorBackgroundBlue
                cell.lblWeekName.textColor = UIColor.white
            } else {
                cell.lblWeekName.backgroundColor = UIColor.white
                cell.lblWeekName.textColor = self.colorBackgroundBlue
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  collectionView == self.collectionViewWeeks {
            
            self.arrOfSelectedWeekName.removeAll()
            self.arrOfSelectedWeekName.append(indexPath)
            collectionViewWeeks.reloadData()
            
            switch indexPath.item {
            case 1:
                self.rangeLimit = 7
                self.arrOfWeekFilter = self.getDatesAlongWithRange(forLastNDays: 365, previousDates: false)

            case 2:
                self.rangeLimit = 14
                self.arrOfWeekFilter = self.getDatesAlongWithRange(forLastNDays: 365, previousDates: false)

            case 3:
                self.arrOfWeekFilter = self.getOneMonthData(forLastNDays: 365, previousDates: false)
            case 4:
                self.arrOfWeekFilter = self.getThreeMonthData(forLastNDays: 365, previousDates: false)
            default:
                break
            }

            self.arrOfSelectedWeekFilter.removeAll()
            collectionViewWeeksFilter.reloadData()
            
        } else if collectionView == self.collectionViewWeeksFilter {
            print(self.arrOfWeekFilter[indexPath.item][self.values]!)
            
            self.arrOfSelectedWeekFilter.removeAll()
            self.arrOfSelectedWeekFilter.append(indexPath)
            collectionViewWeeksFilter.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.collectionViewWeeks {
            return CGSize(width: 100.0, height: 40.0)
        } else {
            return CGSize(width: 120.0, height: 40.0)

        }
    }
    
    
}
