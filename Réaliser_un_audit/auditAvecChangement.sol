//last version
pragma solidity 0.8.0;

//Importation de SafeMath
import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Crowdsale {
   using SafeMath for uint256;
   bool internal locked;
 
   address public owner; // the owner of the contract              
   //address payable public escrow; // wallet to collect raised ETH
   uint256 public savedBalance = 0; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
   
   modifier noReentrant(){
       require (!locked,"No re-entrancy");
       locked = true;
       _;
       locked = false;
   }
   
   
   
   // Initialization
   constructor() public{
       owner = msg.sender;                             // Ne pas utiliser tx.origin mais msg.sender
       // add address of the specific contract
       //escrow = _escrow;
   }
  
   // function to receive ETH FALLBACK 
   receive() external payable noReentrant {         //fallback doit etre external et payable et dans la 0.8 on utilise receive 
       balances[msg.sender] = balances[msg.sender].add(msg.value);
       savedBalance = savedBalance.add(msg.value);
       //escrow.transfer(msg.value);//Eviter le .send car n'envoie pas d'exception en cas d'erreur
   }
  
   // refund investisor
   function withdrawPayments() public payable noReentrant{
       address payee = msg.sender;//Optimisation de cote, pas utile
       uint256 payment = balances[payee];//Optimisation de code, pas utile
       //ERR1 : Balance vide
       require(balances[payee] > 0,"ERR1");
       savedBalance = savedBalance.sub(balances[msg.sender]);
       balances[msg.sender] = 0;
       payable(msg.sender).transfer(payment);
       
   }
}