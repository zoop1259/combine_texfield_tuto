//
//  MyViewModel.swift
//  combine_texfield_tuto
//
//  Created by 강대민 on 2022/06/13.
//

import Foundation
import Combine

//뷰모델 생성
class MyViewModel {
    
    //published 어노테이션을 통해 구독이 가능하도록 설정
    @Published var passwordInput : String = "" {
        didSet {
            print("뷰모델의 패스워드 입력됨 : \(passwordInput)")
        }
    }
    @Published var passwordConfirmInput : String = "" {
        didSet {
            print("뷰모델의 패스워드확인 입력됨 : \(passwordConfirmInput)")
        }
    }
    
    lazy var isMatchPasswordInput : AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .map({ (password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
        })
        .print()
        .eraseToAnyPublisher()
}
