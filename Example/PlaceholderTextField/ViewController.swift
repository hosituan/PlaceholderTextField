//
//  ViewController.swift
//  PlaceholderTextView
//
//  Created by hosituan on 09/19/2021.
//  Copyright (c) 2021 hosituan. All rights reserved.
//

import UIKit
import PlaceholderTextView
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 16
        }
        view.addSubview(stackView)
        let textView1 = PlaceholderTextView(placeholder: "Height").then  {
            $0.height = 80
            $0.textColor = .red
        }
        
        let textView2 = PlaceholderTextView().then {
            $0.placeholder = "Secure"
            $0.isSecure = true
        }
        let textView3 = PlaceholderTextView().then {
            $0.placeholder = "CornerRadius"
            $0.borderCornerRadius = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        let textView4 = PlaceholderTextView().then {
            $0.placeholder = "Font"
            $0.font = .systemFont(ofSize: 30)
            
        }
        let textView5 = PlaceholderTextView().then {
            $0.placeholder = "Required "
            $0.isRequired = true
        }
        let textView6 = PlaceholderTextView().then {
            $0.placeholder = "Hide clear button "
            $0.hasClearButton = false
        }
        let textView7 = PlaceholderTextView().then {
            $0.placeholder = "Has icon"
            $0.rightIcon = UIImage(named: "iconCamera")
            $0.rightButtonAction = {
                print("action")
            }
        }

        
        stackView.addArrangedSubview(textView1)
        stackView.addArrangedSubview(textView2)
        stackView.addArrangedSubview(textView3)
        stackView.addArrangedSubview(textView4)
        stackView.addArrangedSubview(textView5)
        stackView.addArrangedSubview(textView6)
        stackView.addArrangedSubview(textView7)
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

