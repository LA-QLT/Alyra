// Crowdsale.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";


    /*
    * @title Admin
    * @dev  Serveur Administrateur
    */
 
contract Admin is Ownable{
   
   constructor() public Ownable() {
       
   }
      
    mapping(address=> bool) authorized;
   
    
    event Whitelisted(address _address); // Event
    event Blacklisted(address _address); // Event
    
    
    /*
    * @title whitelist
    * L’administrateur est le seul qui a le droit d’autoriser un compte
    */
 
   function whitelist(address  _address) public onlyOwner{
       authorized[_address]=true;
       emit Whitelisted(_address);
   }
   
   /*
    * @title blacklist
    * L’administrateur est le seul qui a le droit de bloquer un compte
    */
   function blacklist(address  _address) public onlyOwner {
       authorized[_address]=false;
       emit Blacklisted(_address);
   }
   
    /*
    * @title isWhitelisted
    * précise si un compte est whitelisté
    */
    
   function isWhitelisted(address  _address) public view returns (bool){
       if(authorized[_address]==true){
           return true;
       }
       return false;
   }
   
   /*
    * @title isBlacklisted
    * précise si un compte est blacklisté
    */
   function isBlacklisted(address  _address) public view returns (bool){
       if(authorized[_address]==false){
           return true;
       }
       return false;
   }
}