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
    mapping (uint => Proposal) public proposition; // Ou sinon methode avec un tableau de type Proposal
    uint public id; //Nombre de proposition 
    uint public winningProposalId=2;
     
    
    
    /*
    * @title electeur
    * L’administrateur est le seul qui a le droit d’autoriser un compte
    */
 
   function whitelist(address  _address) public onlyOwner{
       electeur[_address].isRegistered=true;
   }
   
   function isWhitelisted(address  _address) public view returns (bool){
       if(electeur[_address].isRegistered==true){
           return true;
       }
       return false;
   }
   
   
    function StartSessionEnrigrement () public onlyOwner{
        
        
    }
    
    
    function Addproposal (string memory _information)public  returns(uint){
        id +=1;
        proposition[id]=Proposal(_information,0);
        
    }
    
    function Returnproposal (uint num)public view returns(string memory){
        return proposition[num].description;
        
    }
    
    function EndSessionEnrigrement () public onlyOwner{
       
    }
    
    
    function StartSessionVote () public onlyOwner{
       
    }
    
    function Vote (uint idPropal) public {
        proposition[idPropal].voteCount ++;
       
    }
    function Returnnbvote (uint idPropal)public view returns(uint){
        return proposition[idPropal].voteCount;
        
    }
    function EndSessionVote () public onlyOwner{
       
    }
    
    function Comptabilise () public returns(uint){
       uint max=0;
       for (uint i; i<id;i++){
           if(proposition[i].voteCount > max){
               max = proposition[i].voteCount;
               winningProposalId = i;
           }
       }
       return winningProposalId;
       
    }
    
    function Check () public view returns(uint){
      return proposition[winningProposalId].voteCount;  
    }
    
     function winningProposal () public view returns(uint){
      return winningProposalId;  
    }
    
    
    
    
}