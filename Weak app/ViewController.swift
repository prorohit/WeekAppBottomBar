//
//  ViewController.swift
//  Weak app
//
//  Created by Rohit Singh on 11/22/17.
//  Copyright © 2017 Rohit Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let heightOfView = 300.0
    let startDateForWeeks = Date()
    
    var ticketHeight : NSLayoutConstraint?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let view = BottomDrawerView.loadView() as! BottomDrawerView
        //view.configuration()
        view.sendCallBackOnButtonClick { (value) in
            print(value)
            if value {
                
                UIView.transition(with: view, duration: 0.3, options: .curveEaseIn, animations: {
                    self.ticketHeight?.constant = 50
                    self.ticketHeight?.isActive = true
                    self.view.layoutIfNeeded()
                    
                }, completion: { (val) in
                    
                })
    
            } else {
                UIView.transition(with: view, duration: 0.3, options: .curveEaseIn, animations: {
                   self.ticketHeight?.constant = 300
                    self.view.layoutIfNeeded()

                }, completion: { (val) in
                    
                })
            }
        }
        

        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let margins = self.view.layoutMarginsGuide
        
        // ~For Testing Purpose
        //myView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //myView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        //myView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        view.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        self.ticketHeight = view.heightAnchor.constraint(equalToConstant: CGFloat(heightOfView))
        view.heightAnchor.constraint(equalToConstant: CGFloat(heightOfView)).isActive = true

    }

  
    
    func getDates(forLastNDays nDays: Int, previousDates: Bool) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = startDateForWeeks

        
        var arrDates = [String]()
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "MMM dd"

        arrDates.append(dateFormatter.string(from: date))
        
        for _ in 0 ... nDays {
            // move back in time by one day:
            let val = previousDates ? -1 : 1;
            date = cal.date(byAdding: Calendar.Component.day, value: val, to: date)!
            
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
}



