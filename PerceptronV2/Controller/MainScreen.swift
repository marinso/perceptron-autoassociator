//
//  MainScreen.swift
//  PerceptronV2
//
//  Created by Martin Nasierowski on 14/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MainScreen: UIViewController, SetPointsDelegate {
    
    // MARK: - Properties
    private var perceptrons = [Perceptron]()
    
    private var ref: DatabaseReference!
    
    private var table = [Float]()
    private var table_2 = [Float]()

    private var examples = [Example]()
    private var threads = [Thread]()
    
    var exampleNumber = 0
    
    private var currentIndex = -1

    private let leftView: Canvas = {
        let leftView = Canvas()
        leftView.backgroundColor = .white
        leftView.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        return leftView
    }()
    
    private let rightView: Canvas = {
        let rightView = Canvas()
        rightView.backgroundColor = .white
        return rightView
    }()
    
    private let reDrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn", for: .normal)
        button.addTarget(self, action: #selector(learnHandle), for: .touchUpInside)
        button.backgroundColor = .white
        button.frame = CGRect(x: 50, y: 280, width: 80, height: 20)
        return button
    }()
    
    private let checkButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Check", for: .normal)
           button.addTarget(self, action: #selector(checkResult), for: .touchUpInside)
           button.backgroundColor = .white
           button.frame = CGRect(x: 250, y: 280, width: 80, height: 20)
           return button
   }()
    
    private let recursiveButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Recursive", for: .normal)
          button.addTarget(self, action: #selector(recursive), for: .touchUpInside)
          button.backgroundColor = .white
          button.frame = CGRect(x: 350, y: 280, width: 80, height: 20)
          return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchUpInside)
        button.backgroundColor = .white
        button.frame = CGRect(x: 150, y: 280, width: 80, height: 20)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(previousPicture), for: .touchUpInside)
        button.backgroundColor = .white
        button.isEnabled = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(nextPicture), for: .touchUpInside)
        button.backgroundColor = .white
        button.frame = CGRect(x: 150, y: 280, width: 80, height: 20)
        return button
    }()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        view.backgroundColor = .black
                
        view.addSubview(rightView)
        view.addSubview(leftView)
        view.addSubview(reDrawButton)
        view.addSubview(clearButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(checkButton)
        view.addSubview(recursiveButton)
        
        leftView.delegate = self
        
        rightView.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 0, paddingRight: 50, width: 200, height: 200)
        
        previousButton.anchor(top: rightView.bottomAnchor, bottom: nil, left: rightView.leftAnchor , right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 20, paddingRight: 0, width: 35, height: 35)
        
        nextButton.anchor(top: rightView.bottomAnchor, bottom: nil, left: nil, right: rightView.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 0, paddingRight: 20, width: 35, height: 35)
        
        setTable()
        fetchExamples()
        setEnableButton()
    }
    
    // MARK: - CustomViewActions
    func setPoint(_ points: [Float]) {
        self.table = points
    }
    
    private func getPicture() {
        rightView.clear()
        leftView.clear()
        
        let current_table = examples[currentIndex].table
        
        table = current_table
        
        rightView.reDraw(table)
//        leftView.reDraw(table)
    }
    
    
    // MARK: - Handlers
    
    @objc func recursive() {
        for _ in 0...10 {
            checkResult()
        }
    }
    
    @objc func checkResult() {
//        table_2 = table
        
        for i in 0...2499
        {
            if perceptrons[i].checkResult(table) == 1 {
                table_2[i+1] = 1
            } else {
                table_2[i+1] = 0
            }
        }
       
        table = table_2
        leftView.reDraw(table_2)
    }
    
    @objc func clear() {
        leftView.clear()
        rightView.clear()
        clearTable()
    }
    
    @objc func nextPicture() {
        if currentIndex < examples.count {
            currentIndex += 1
            setEnableButton()
            getPicture()
        }
    }
    
    @objc func previousPicture() {
        if currentIndex > 0 {
           currentIndex -= 1
           setEnableButton()
           getPicture()
       }
    }
    
    // MARK: - SETUP
    
    private func setEnableButton() {
        if currentIndex <= 0 {
            previousButton.isEnabled = false
        } else {
            previousButton.isEnabled = true
        }
        
        if currentIndex == examples.count-1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    private func setTable() {
//        table = [Float](repeating: 0.0, count: 2500)
        table_2 = [Float](repeating: 0.0, count: 2500)
        table_2.insert(1, at: 0)
    }
    
    private func clearTable() {
        for (index, _) in table.enumerated() {
            table[index] = 0
            table_2[index] = 0
        }
        
        table[0] = 1
        table_2[0] = 1
    }
    
    // MARK: - API

    private func  pushToDatabase(with example:Example) {
       let uuid = NSUUID().uuidString
       self.ref.child("examples").child(uuid).setValue(["number": example.number, "table": example.table])
    }
    
    private func fetchExamples() {

        let ref = Database.database().reference()

        ref.child("examples").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else { return }
            let example = Example.init(with: dictionary["number"] as! Int, for: dictionary["table"] as! [Float])
            example.table.insert(1, at: 0)
            self.examples.append(example)
            self.setEnableButton()
        }
    }
    
    // MARK: - Perceptrons
    
    @objc func learnHandle() {
        createPerceptron()

        
        for i in 0...4  {
            threads.append(Thread.init(block: {
                if i == 0 {
                    self.addThread(0, 500)
                } else if i == 4 {
                    self.addThread( i * 500 + 1, i * 500 + 499 )
                } else {
                    self.addThread( i * 500 + 1, i * 500 + 500 )
                }
            }))
        }

        threads.forEach { (thread) in
            thread.start()
        }
    }
    
    func addThread(_ start:Int, _ end:Int) {
        for i in start...end {
           perceptrons[i].learn()
        }
    }
    
    private func createPerceptron() {
        for i in 1...2500 {
           let perceptron = Perceptron.init(which: i, self.examples)
            self.perceptrons.append(perceptron)
       }
    }
}
