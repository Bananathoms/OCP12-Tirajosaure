//
//  SortedModelTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 29/06/2024.
//

import Foundation
import XCTest
@testable import Tirajosaure
import ParseSwift

class SortedModelTests: XCTestCase {
    
    func testSortedTeamsWithMembers() {
        // Initialiser les résultats d'équipe avec des équipes et des membres non triés
        let teamResults = [
            TeamResult(name: "TeamB", members: ["Charlie", "Alice"], draw: Pointer<TeamsDraw>(objectId: "DrawId")),
            TeamResult(name: "TeamA", members: ["Eve", "Bob"], draw: Pointer<TeamsDraw>(objectId: "DrawId"))
        ]
        
        // Appeler la fonction pour trier les résultats d'équipe et les membres
        let sortedResults = SortedModel.sortedTeamsWithMembers(teamResults)
        
        // Vérifier que les équipes sont triées par nom
        XCTAssertEqual(sortedResults[0].name, "TeamA")
        XCTAssertEqual(sortedResults[1].name, "TeamB")
        
        // Vérifier que les membres de chaque équipe sont triés par nom
        XCTAssertEqual(sortedResults[0].members, ["Bob", "Eve"])
        XCTAssertEqual(sortedResults[1].members, ["Alice", "Charlie"])
    }
    
    func testSortedTeamsWithMembersEmpty() {
        // Initialiser les résultats d'équipe vides
        let teamResults: [TeamResult] = []
        
        // Appeler la fonction pour trier les résultats d'équipe et les membres
        let sortedResults = SortedModel.sortedTeamsWithMembers(teamResults)
        
        // Vérifier que le résultat est également vide
        XCTAssertTrue(sortedResults.isEmpty)
    }
    
    func testSortedTeamsWithMembersSingleTeam() {
        // Initialiser les résultats d'équipe avec une seule équipe non triée
        let teamResults = [
            TeamResult(name: "TeamA", members: ["Charlie", "Alice"], draw: Pointer<TeamsDraw>(objectId: "DrawId"))
        ]
        
        // Appeler la fonction pour trier les résultats d'équipe et les membres
        let sortedResults = SortedModel.sortedTeamsWithMembers(teamResults)
        
        // Vérifier que l'équipe unique est triée
        XCTAssertEqual(sortedResults[0].name, "TeamA")
        
        // Vérifier que les membres de l'équipe sont triés par nom
        XCTAssertEqual(sortedResults[0].members, ["Alice", "Charlie"])
    }
    
    func testSortedTeamsWithMembersMultipleTeamsSameName() {
        // Initialiser les résultats d'équipe avec des équipes ayant le même nom mais des membres non triés
        let teamResults = [
            TeamResult(name: "TeamA", members: ["Charlie", "Alice"], draw: Pointer<TeamsDraw>(objectId: "DrawId1")),
            TeamResult(name: "TeamA", members: ["Eve", "Bob"], draw: Pointer<TeamsDraw>(objectId: "DrawId2"))
        ]
        
        // Appeler la fonction pour trier les résultats d'équipe et les membres
        let sortedResults = SortedModel.sortedTeamsWithMembers(teamResults)
        
        // Vérifier que les équipes sont triées par nom
        XCTAssertEqual(sortedResults[0].name, "TeamA")
        XCTAssertEqual(sortedResults[1].name, "TeamA")
        
        // Vérifier que les membres de chaque équipe sont triés par nom
        XCTAssertEqual(sortedResults[0].members, ["Alice", "Charlie"])
        XCTAssertEqual(sortedResults[1].members, ["Bob", "Eve"])
    }
    
    func testSortedTeamsWithMembersMixed() {
        // Initialiser les résultats d'équipe avec des équipes ayant des noms et des membres non triés
        let teamResults = [
            TeamResult(name: "TeamC", members: ["Charlie", "Alice"], draw: Pointer<TeamsDraw>(objectId: "DrawId1")),
            TeamResult(name: "TeamA", members: ["Eve", "Bob"], draw: Pointer<TeamsDraw>(objectId: "DrawId2")),
            TeamResult(name: "TeamB", members: ["George", "Frank"], draw: Pointer<TeamsDraw>(objectId: "DrawId3"))
        ]
        
        // Appeler la fonction pour trier les résultats d'équipe et les membres
        let sortedResults = SortedModel.sortedTeamsWithMembers(teamResults)
        
        // Vérifier que les équipes sont triées par nom
        XCTAssertEqual(sortedResults[0].name, "TeamA")
        XCTAssertEqual(sortedResults[1].name, "TeamB")
        XCTAssertEqual(sortedResults[2].name, "TeamC")
        
        // Vérifier que les membres de chaque équipe sont triés par nom
        XCTAssertEqual(sortedResults[0].members, ["Bob", "Eve"])
        XCTAssertEqual(sortedResults[1].members, ["Frank", "George"])
        XCTAssertEqual(sortedResults[2].members, ["Alice", "Charlie"])
    }
}
