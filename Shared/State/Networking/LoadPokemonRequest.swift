//
//  LoadPokemonRequest.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/24.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct LoadMemoRequest {
    static var all: AnyPublisher<[Memo], AppError> {
        LoadMemoRequest().publisher
            .map {
                $0.memos
            }
            .eraseToAnyPublisher()
    }

    var publisher: AnyPublisher<APIMemos, AppError> {
        memoPublisher()
            .mapError { AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func memoPublisher() -> AnyPublisher<APIMemos, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://pokeapi.co/api/v2/pokemon/")!)
            .map { $0.data }
            .decode(type: APIMemos.self, decoder: appDecoder)
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
