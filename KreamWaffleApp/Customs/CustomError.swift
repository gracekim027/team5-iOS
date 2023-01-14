//
//  CustomError.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/14.
//

import Foundation

enum LoginError: Error {
    case noUserInfoError //그 이메일로 가입된 회원이 없을 때.
    case emailFormatError //이메일이 제대로된 이메일이 아닐때.
    case passwordFormatError //password 이 제대로된 password 가 아닐때.
    case unknownError //그이외의 error
    case noError //초기값을 갖기 위해서
    case signupError 
 }

func checkErrorMessage(_ errorMessage: String) -> LoginError{
    switch errorMessage {
    case "이 필드는 blank 일 수 없습니다.":
        return .passwordFormatError
    default:
        return .unknownError
    }
    }
