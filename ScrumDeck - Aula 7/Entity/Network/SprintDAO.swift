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
        let sprint = Sprint(nome: title, link: link ?? kBaseURL)
        let data = (try? JSONEncoder().encode(sprint)) ?? Data()
        
        var request = try! URLRequest(url: "\(kBaseURL)/sprint", method: .post)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return RxAlamofire
            .requestResponse(request)
            .debug()
            .map { result in
                return nil
            }
    }
}
