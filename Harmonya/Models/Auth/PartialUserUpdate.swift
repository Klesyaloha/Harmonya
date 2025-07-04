//
//  PartialUserUpdate.swift
//  ZakFit
//
//  Created by Klesya on 20/12/2024.
//

// Modèle des champs partiels à mettre à jour
struct PartialUserUpdate: Codable {
    var nameUser: String?
    var surname: String?
    var email: String?
    var password: String?
    var cycles : [Cycle]?
    var genre : Genre?
}
