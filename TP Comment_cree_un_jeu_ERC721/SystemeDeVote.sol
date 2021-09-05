// Crowdsale.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;
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
    
    mapping (address => Voter) public electeur;
    Proposal [] public proposition;
    uint public winningProposalId=0;
     
    
/*********************************************************************************************************
 * L'administrateur du vote enregistre une liste blanche d'électeurs identifiés par leur adresse Ethereum.
 * 
 ***********************************************************************************************************/
 
 
   function whitelist(address  _address) public onlyOwner{
       require(!electeur[_address].isRegistered, "This address is already isRegistered !");
       electeur[_address].isRegistered=true;
       emit VoterRegistered(_address);
   }
   
   
/*********************************************************************************************************
 *          L'administrateur du vote commence la session d'enregistrement de la proposition.
 * 
 ***********************************************************************************************************/
   
    function StartSessionEnrigrement () public onlyOwner{
        emit ProposalsRegistrationStarted();
    }
    
/*********************************************************************************************************
 *          Les électeurs inscrits sont autorisés à enregistrer leurs propositions pendant que 
 *                              la session d'enregistrement est active.
 * 
 ***********************************************************************************************************/
    
    function Addproposal (string memory  _information) public{
        require(electeur[msg.sender].isRegistered==true,"Ne figure pas dans la whitelist");
        Proposal memory newPropo = Proposal(_information, 0); 
        proposition.push(newPropo);
        
    }
    
/*********************************************************************************************************
 *          L'administrateur de vote met fin à la session d'enregistrement des propositions.
 * 
 ***********************************************************************************************************/ 
 
    function EndSessionEnrigrement () public onlyOwner{
       emit ProposalsRegistrationEnded();
    }
    
/*********************************************************************************************************
 *          L'administrateur du vote commence la session de vote.
 * 
 ***********************************************************************************************************/ 
 
    function StartSessionVote () public onlyOwner{
       emit VotingSessionStarted();
    }
    
/*********************************************************************************************************
 *         Les électeurs inscrits votent pour leurs propositions préférées.
 * 
 ***********************************************************************************************************/ 
 
    function Vote (uint idPropal) public {
        require(!electeur[msg.sender].hasVoted,"vous avez deja vote");
        proposition[idPropal].voteCount ++;
        electeur[msg.sender].hasVoted=true;
        electeur[msg.sender].votedProposalId=idPropal;
       
    }
    
/*********************************************************************************************************
 *         L'administrateur du vote met fin à la session de vote.
 ***********************************************************************************************************/    
   
    function EndSessionVote () public onlyOwner{
       emit VotingSessionEnded();
    }
   
/*********************************************************************************************************
 *         L'administrateur du vote comptabilise les votes.
 *******************************************************************************************************/
 
 
    function Comptabilise () external  {
       uint max =0;
       for(uint i; i<proposition.length;i++){
           if (proposition[i].voteCount >max){
               max =proposition[i].voteCount;
               winningProposalId=i;
           }
       }
    }
    
/*********************************************************************************************************
 *         Tout le monde peut vérifier les derniers détails de la proposition gagnante.
 *******************************************************************************************************/    
    
    function CheckNbVote (uint id) public view returns(uint){
      return proposition[id].voteCount;  
    }
    function CheckId (uint id) public pure returns(uint){
      return id;  
    }
    function CheckInformation (uint id) public view returns(string memory){
      return proposition[id].description;  
    }
    
    
/*********************************************************************************************************
 *         Tout le monde peut vérifier les derniers détails de la proposition gagnante.
 *******************************************************************************************************/        
   
   function isWhitelisted(address  _address) public view returns (bool){
       if(electeur[_address].isRegistered==true){
           return true;
       }
       return false;
   }
    
}