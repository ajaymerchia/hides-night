//
//  TeamMemberSelectVC.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit

class TeamMemberSelectVC: UIViewController {

    var game: Game!
    var team: Team!
    var slots: [User?]!
    var slotIndex: Int!
    
    var tableview: UITableView!
    var tableData = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAvailableMembers()
        // Do any additional setup after loading the view.
        initUI()
    }
    
    func getAvailableMembers() {
        
        var takenPlayers = [User]()
        for team in game.teams.values {
            for takenPlayer in team.getMembersOfTeamFrom(game: self.game) {
                if self.team.uid == team.uid && !slots.contains(takenPlayer) { continue } else {
                    takenPlayers.append(takenPlayer)
                }
            }
        }
        
        for player in game.players {
            if slots.contains(player) {
                continue
            }
            if takenPlayers.contains(player) {
                continue
            }
            tableData.append(player)
        }
        tableData.sort()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let cellUser = tableData[indexPath.row]
        
        cell.awakeFromNib()
        cell.initializeCellFrom(data: cellUser, size: CGSize(width: view.frame.width, height: 60), blackBack: true)
        cell.profilePic.setImage(cellUser.profilePic, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slots[slotIndex] = tableData[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    

}
