//
//  ServiceHelper.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation
import Alamofire
import RxSwift

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}


class ServiceHelper{
    private func dataRequest(_ urlString: String, method: HTTPMethod = .get, parameters: Parameters?, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, onCompleted: @escaping (AFDataResponse<Data?>) -> Void) -> DataRequest {
        AF.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            #if DEBUG
            print("ServiceWrapper: Request Headers: \(String(describing: response.request?.headers))")
            print("ServiceWrapper: Response: \(response.debugDescription)")
            #endif
            onCompleted(response)
        }
    }
    
    func request<R: Encodable>(_ endPoint: String,
                        method: HTTPMethod = .get,
                        parameter: R? = nil,
                        encoding: ParameterEncoding = URLEncoding.queryString) -> Observable<(Data?, ServiceError?)>  {
        
        let baseURL = "\(endPoint)"
        
        let param = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(parameter))) as? [String: Any] ?? [:]
        
        guard Connectivity.isConnectedToInternet else {
            return Observable<(Data?, ServiceError?)>.create { observer in
                
                observer.onNext((nil, .noInternet))
                observer.onCompleted()
                
                return Disposables.create()
            }
        }
        
        return Observable<(Data?, ServiceError?)>.create { observer in
            let request = self.dataRequest(baseURL, method: method, parameters: param, encoding: encoding) { response in
                observer.onNext((response.data, nil))
                observer.onCompleted()
            }
            return Disposables.create{
                request.cancel()
            }
        }

    }
}
