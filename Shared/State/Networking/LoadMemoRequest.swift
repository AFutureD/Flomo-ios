//
//  LoadPokemonRequest.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/24.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine
import Alamofire

struct LoadMemoRequest {
    let user: User
    
//    var all: AnyPublisher<[Memo], AppError> {
//        LoadMemoRequest().publisher
//            .eraseToAnyPublisher()
//    }

//    var publisher: AnyPublisher<APIMemos, AppError> {
//        memoPublisher()
//            .mapError { AppError.networkingFailed($0) }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }

    var publisher: AnyPublisher<[Memo], AppError> {
//        URLSession.shared
//            .dataTaskPublisher(for: URL(string: "https://pokeapi.co/api/v2/pokemon/")!)
//            .map { $0.data }
//            .decode(type: APIMemos.self, decoder: appDecoder)
//            .eraseToAnyPublisher()
        Future { promise in
            var headers: HTTPHeaders = [
            // TODO: pass x-xsrf-token to api.
                "X-XSRF-TOKEN": user.token
            ]
            AF.request("https://flomo.app/api/memo",method: .get,headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        guard let getMemosAPIResponse = try? JSONDecoder().decode(APIMemos.self, from: data)  else {
                            return promise(.failure(AppError.parseDataToJSONFailed))
                        }
                        switch getMemosAPIResponse.code{
                        case 0:
                            promise(.success(getMemosAPIResponse.memos))
                        default:
                            promise(.failure(AppError.fetchFailed(getMemosAPIResponse.message)))
                        }
                    case let .failure(error):
                        promise(.failure(AppError.networkingFailed(error)))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()

//        URLSession.shared.dataTask(with: URL(string: "")!).
    }

//    private func speciesPublisher(_ pokemon: Pokemon) -> AnyPublisher<(Pokemon, PokemonSpecies), Error> {
//        URLSession.shared
//            .dataTaskPublisher(for: pokemon.species.url)
//            .map { $0.data }
//            .decode(type: PokemonSpecies.self, decoder: appDecoder)
//            .map { (pokemon, $0) }
//            .eraseToAnyPublisher()
//    }
}
