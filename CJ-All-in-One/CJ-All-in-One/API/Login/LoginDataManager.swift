import Foundation
import Alamofire

class LogInDataManager {

    func postLogIn(userID: String, userPassword: String, viewController: SignInViewController) {
        
        let urlString = "\(base_url)/user/login?userID=\(userID)&userPassword=\(userPassword)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
       
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: LoginResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.success, let result = response.userInfo {
                        viewController.didSuccessLogIn(result: result)
                    } else {
                        viewController.failedToLogIn(message: response.msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    viewController.failedToLogIn(message: "서버와의 연결이 좋지 않습니다.")
                }
            }
        }
    }
}
