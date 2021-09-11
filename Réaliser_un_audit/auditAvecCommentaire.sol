
//last version
pragma solidity 0.5.0;

//Importation de SafeMath


contract Crowdsale {
   using SafeMath for uint256;
 
   address public owner; // the owner of the contract              
   address public escrow; // wallet to collect raised ETH
   uint256 public savedBalance = 0; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
 
   // Initialization
   function Crowdsale(address _escrow) public{
       owner = tx.origin;                             // Ne pas utiliser tx.origin mais msg.sender
       // add address of the specific contract
       escrow = _escrow;
   }
  
   // function to receive ETH FALLBACK 
   function() public {         //fallback doit etre external et payable et dans la 0.8 on utilise receive 
       balances[msg.sender] = balances[msg.sender].add(msg.value);
       savedBalance = savedBalance.add(msg.value);
       escrow.send(msg.value);//Eviter le .send car n'envoie pas d'exception en cas d'erreur
   }
  
   // refund investisor
   function withdrawPayments() public{
       address payee = msg.sender;//Optimisation de cote
       uint256 payment = balances[payee];//Optimisation de code 
        //require : verifier que la balance ne soit pas egal a 0;
       payee.send(payment);//Eviter le .send car n'envoie pas d'exception en cas d'erreur, utilise .transfer
 
       savedBalance = savedBalance.sub(payment);//faire les changement d'etat avant l'envoi du .send car REENTRANCE
       balances[payee] = 0;//faire les changement d'etat avant l'envoi du .send ansfer car REENTRANCE
   }
}