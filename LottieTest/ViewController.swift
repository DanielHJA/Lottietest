//
//  ViewController.swift
//  LottieTest
//
//  Created by Daniel Hjärtström on 2020-06-16.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    var items = [1,2,3,4,5,6,7,8,9]
    
    private lazy var animationView: LottieAnimationView = {
        let temp = LottieAnimationView()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        return temp
    }()
    
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        temp.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: animationView.bottomAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var barButtonItem: UIBarButtonItem = {
        var lottieView = LottieAnimatedButton()
        let temp = UIBarButtonItem(customView: lottieView)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = barButtonItem
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section) - \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.y / scrollView.contentSize.height
        animationView.animationView.currentProgress = progress
    }
    
}

class LottieAnimationView: UIView, UIScrollViewDelegate {
    
    private(set) lazy var animationView: AnimationView = {
        let temp = AnimationView(name: "tutorial")
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        animationView.contentMode = .scaleAspectFill
        addSubview(animationView)
    }
    
}

class LottieAnimatedButton: UIView {
    
    var menuActive = false
    var animationView: AnimationView?
    var itemButtonFrame = CGRect(x: -15.0, y: -15.0, width: 70, height: 70)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.frame = itemButtonFrame
        addMenuButton(false)
    }
    
    func addMenuButton(_ on: Bool) {
        if animationView != nil {
            self.animationView?.removeFromSuperview()
            self.animationView = nil
        }
        
        let animation = menuActive ? "buttonOff" : "buttonOn"
        animationView = AnimationView(name: animation)
        
        animationView!.isUserInteractionEnabled = true
        animationView!.frame = itemButtonFrame
        animationView!.contentMode = .scaleAspectFill
        addToggleRecognizer()
        addSubview(animationView!)
    }
    
    func addToggleRecognizer() {
        guard let animationView = animationView else { return }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleMenu(_:)))
        animationView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func toggleMenu(_ sender: UITapGestureRecognizer) {
        menuActive ? setMenuOffAndPerformAction() : setMenuOnAndPerformAction()
    }
    
    func setMenuOnAndPerformAction() {
            animationView?.play(completion: { (success) in
                    self.menuActive = true
                    self.addMenuButton(self.menuActive)
                DispatchQueue.main.async {
                    print("menu is ON")
                }
            })
        }
    func setMenuOffAndPerformAction() {
            
            animationView?.play(completion: { (success) in
                self.menuActive = false
                self.addMenuButton(self.menuActive)
                DispatchQueue.main.async {
                    print("menu is OFF")
                }
            })
        }
}
