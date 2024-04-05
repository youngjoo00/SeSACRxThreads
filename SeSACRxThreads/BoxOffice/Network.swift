//
//  Network.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class BoxOfficeNetwork {
    
    static func fetchBoxOfficeData(date: String) -> Observable<Movie> {
        
        return Observable<Movie>.create { observer in
            
            guard let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=\(date)") else {
                observer.onError(APIError.invalidURL)
                return Disposables.create() // 오류나면 끝내기
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("DataTask Succeed")
                
                if let _ = error {
                    print("Error")
                    return observer.onError(APIError.unknownResponse)
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print("Response Error")
                    return observer.onError(APIError.statusError)
                }
                
                if let data = data,
                    let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    print(appData)
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("통신은 했는데 디코딩 실패")
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()
            return Disposables.create()
        }.debug()
        
    }
}
