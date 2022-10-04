//
//  TestViewController.swift
//  Runner
//
//  Created by Meo Luoi on 18/11/2020.
//

import UIKit

class TestViewController: UIViewController {
    weak var callback : TestDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Check Me!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 50)
        button.addTarget(
          self,
          action: #selector(swapButtonWasTouched),
          for: .touchUpInside)
        view.addSubview(button)
        // Put button at the center of the view
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    
    @objc private func swapButtonWasTouched(_ sender: UIButton) {
      callback?.getTestName(name: "test nè")
        MethodChannel.instance.sendEventNetAloSessionExpire()
    _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func loadView() {
      let view = UIView()
      view.backgroundColor = .red
      self.view = view
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
protocol TestDelegate: class {
    func getTestName(name:String)
}
