//
//  SprintDAO.swift
//  ScrumDeck - Aula 7
//
//  Created by Euler Carvalho on 17/06/21.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

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
    
    static func deleteSprint(by id: Int) -> Observable<Any> {
        return RxAlamofire
            .request(.delete, "\(kBaseURL)/sprint/\(id)")
            .debug()
            .map({ result in
                return result
            })
    }
    
    static func createSprint(with title: String, link: String?) -> Observable<Sprint?>{
        return RxAlamofire
            .requestJSON(
                .post,
                "\(kBaseURL)/sprint",
                parameters: ["title" : title, "link": link ?? ""])
            .debug()
            .map { (response) in
                return nil
            }
    }
}
