//
//  MainView.swift
//  PerceptronV2
//
//  Created by Martin Nasierowski on 27/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class MainView: UIViewController {
    
    // MARK: - Properties
    var arraysOfData = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var buttonArray = [UIButton]()
    var hStackArray = [UIStackView]()
    var currentButtonTag = 1
    var vStack: UIStackView!

    let border: UIView = {
        let border = UIView()
        border.frame = CGRect(x: 49, y: 49, width: 202, height: 202)
        border.backgroundColor = .black
        return border
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        createMainVStack()
    }
    
    // MARK: - UI
    
    func createHStack() {
        
        createButtons()
        
        let hStack = UIStackView(arrangedSubviews: buttonArray)
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fillEqually
        hStack.spacing = 0
        hStackArray.append(hStack)
        buttonArray = []
    }
    
    func createMainVStack() {
        
        for _ in 0..<40 {
            createHStack()
        }
        
        vStack = UIStackView(arrangedSubviews: hStackArray)
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.spacing = 0
        vStack.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        view.addSubview(border)
        view.addSubview(vStack)
    }
    
    func createButtons() {
        
        for _ in 1..<41 {
           let button = UIButton(type: .system)
           button.setTitle("", for: .normal)
           button.backgroundColor = .white
           button.tag = currentButtonTag
           button.isUserInteractionEnabled = true
           buttonArray.append(button)
           currentButtonTag += 1
         }
    }
    
    // MARK: - Handlers
    
    @objc func buttonAction(sender: UIButton) {
        if sender.backgroundColor == .white {
            sender.backgroundColor = .red
//            arraysOfData[sender.tag] = 1
        } else {
            sender.backgroundColor = .white
//            arraysOfData[sender.tag] = 0
        }
    }
    
    // MARK: - TOUCHES
    

}
