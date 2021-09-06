// Crowdsale.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";

contract Voting is Ownable{
    
    event VoterRegistered(address voterAddress);
    event ProposalsRegistrationStarted();
    event ProposalsRegistrationEnded();
    event ProposalRegistered(uint proposalId);
    event VotingSessionStarted();
    event VotingSessionEnded();
    event Voted (address voter, uint proposalId);
    event VotesTallied();
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }
    
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    
    mapping (address => Voter) private electeur;
    Proposal [] public proposition;
    uint public winningProposalId=0;
    
    WorkflowStatus public Status = WorkflowStatus.VotingSessionEnded;

     
/*********************************************************************************************************
 * @dev whitelist
 * L'administrateur du vote enregistre une liste blanche d'électeurs identifiés par leur adresse Ethereum.
 * 
 ***********************************************************************************************************/
 
 
   function whitelist(address  _address) public onlyOwner{
       require(!electeur[_address].isRegistered, "This address is already isRegistered !");
       electeur[_address].isRegistered=true;
       emit VoterRegistered(_address);
       
   }
   
   
/*********************************************************************************************************
 * @dev StartSessionEnrigrement
 * L'administrateur du vote commence la session d'enregistrement de la proposition.
 * 
 ***********************************************************************************************************/
   
    function StartSessionEnrigrement () public onlyOwner{
        emit ProposalsRegistrationStarted();
        Status = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded,WorkflowStatus.ProposalsRegistrationStarted);
    }
    
/*********************************************************************************************************
 * @dev Addproposal         
 * Les électeurs inscrits sont autorisés à enregistrer leurs propositions pendant que 
 *                          la session d'enregistrement est active.
 * 
 ***********************************************************************************************************/
    
    function Addproposal (string memory  _information) public{
        require(Status == WorkflowStatus.ProposalsRegistrationStarted,"La session de proposition n'est pas Ouvert");
        require(electeur[msg.sender].isRegistered==true,"Ne figure pas dans la whitelist");
        Proposal memory newPropo = Proposal(_information, 0); 
        proposition.push(newPropo);
        
    }
    
/*********************************************************************************************************
 * @dev EndSessionEnrigrement
 * L'administrateur de vote met fin à la session d'enregistrement des propositions.
 * 
 ***********************************************************************************************************/ 
 
    function EndSessionEnregistrement () public onlyOwner{
       emit ProposalsRegistrationEnded();
       Status = WorkflowStatus.ProposalsRegistrationEnded;
       emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted,WorkflowStatus.ProposalsRegistrationEnded);
    }
    
/*********************************************************************************************************
 * @dev StartSessionVote
 * L'administrateur du vote commence la session de vote.
 * 
 ***********************************************************************************************************/ 
 
    function StartSessionVote () public onlyOwner{
       emit VotingSessionStarted();
       Status = WorkflowStatus.VotingSessionStarted;
       emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded,WorkflowStatus.VotingSessionStarted);
    }
    
/*********************************************************************************************************
 * @dev Vote
 * Les électeurs inscrits votent pour leurs propositions préférées.
 * 
 ***********************************************************************************************************/ 
 
    function Vote (uint idPropal) public {
        require(Status == WorkflowStatus.VotingSessionStarted,"La session de Vote n'est pas Ouvert");
        require(electeur[msg.sender].isRegistered==true,"Ne figure pas dans la whitelist");
        require(!electeur[msg.sender].hasVoted,"vous avez deja vote");
        proposition[idPropal].voteCount ++;
        electeur[msg.sender].hasVoted=true;
        electeur[msg.sender].votedProposalId=idPropal;
        emit Voted(msg.sender,idPropal);
       
    }
    
/*********************************************************************************************************
 * @dev EndSessionVote
 * L'administrateur du vote met fin à la session de vote.
 ***********************************************************************************************************/    
   
    function EndSessionVote () public onlyOwner{
       emit VotingSessionEnded();
       Status = WorkflowStatus.VotingSessionEnded;
       emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted,WorkflowStatus.VotingSessionEnded);
    }
   
/*********************************************************************************************************
 * @dev Comptabilise
 * L'administrateur du vote comptabilise les votes.
 *******************************************************************************************************/
 
 
    function Comptabilise () public  onlyOwner{
       uint max =0;
       for(uint i; i<proposition.length;i++){
           if (proposition[i].voteCount >max){
               max =proposition[i].voteCount;
               winningProposalId=i;
           }
       }
       emit VotesTallied();
       Status = WorkflowStatus.VotesTallied;
       emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded,WorkflowStatus.VotesTallied);
       
       
    }
/*********************************************************************************************************
 * @dev
 * Autre fonctions
 *******************************************************************************************************/    
    
    function CheckWinner () public view returns(Proposal memory){
      return proposition[winningProposalId];  
    }
    
    
   
   function isWhitelisted(address  _address) public view returns (bool){
       if(electeur[_address].isRegistered==true){
           return true;
       }
       return false;
   }
    
}