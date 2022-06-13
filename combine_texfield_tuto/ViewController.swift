//
//  ViewController.swift
//  combine_texfield_tuto
//
//  Created by 강대민 on 2022/06/13.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var myBtn: UIButton!
    
    var viewModel : MyViewModel!
    //메모리 관리
    private var mySubscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        viewModel = MyViewModel()
        
        //텍스트필드에서 나가는 이벤트를
        //뷰모델의 프로퍼티가 구독
        passwordTextField
            .myTextPublisher
//            .print()
        //스레드 - 메인에서 받겠다.
            .receive(on: DispatchQueue.main)
        //구독
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        passwordConfirmTextField
            .myTextPublisher
//            .print()
        //스레드 - 메인에서 받겠다.
        //다른 쓰레드와 같이 작업할때는 RunLoop를 많이 쓴다고 한다.
            .receive(on: RunLoop.main)
        //구독
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        //버튼이 뷰모델의 퍼블리셔를 구독
        viewModel.isMatchPasswordInput
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: myBtn)
            .store(in: &mySubscriptions)
    }


}

extension UITextField {
    var myTextPublisher : AnyPublisher<String, Never> {
        //텍스트필드 자체 노티피케이션에 텍스트가 변경되는걸 감지하는게 있다.
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
//            .print()
        //UITextField 가져오기.
            .compactMap { $0.object as? UITextField }
        //String가져오기. 값이 없다면 빈값
            .map{ $0.text ?? "" }
            .print()
        //이걸 하게 되면 여러가지 맵핑이 되어있는것을 애니퍼블리셔해준다.
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}
