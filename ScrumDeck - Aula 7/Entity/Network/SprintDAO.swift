//
//  SprintDAO.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 17/06/21.
//

import Foundation
import RxSwift
import RxAlamofire

struct SprintDAO {
    static let kBaseURL: String = "https://scrum-deck-backend.herokuapp.com"
    
    static func getSprints() -> Observable<[Sprint]> {
        return RxAlamofire
            .requestDecodable(.get, "\(kBaseURL)/sprint")
            .debug()
            .map { (response, sprints: [Sprint]) in
                return sprints
            }
    }
    
    static func getSprint(by id: Int) -> Observable<Sprint> {
        return RxAlamofire
            .requestDecodable(.get, "\(kBaseURL)/sprint/\(id)")
            .debug()
            .map { (response, sprint: Sprint) in
                return sprint
            }
    }
    
    static func deleteSprint(by id: Int) -> Observable<String> {
        return RxAlamofire
            .requestDecodable(.delete, "\(kBaseURL)/sprint/\(id)")
            .debug()
            .map { (response, result: String) in
                return result
            }
    }
}
