// Crowdsale.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

/**
 * @title Bank
 * @dev  Banque décentralisée 
 */
 
contract Bank {
    mapping (address => uint) public _balances;
    using SafeMath  for uint;

    /**
     * @dev deposit 
     * Permet d'effectuer un dépôt (en modifiant le mapping)
    */
   function deposit(uint _amount) public{
       require(msg.sender != address(0), "You cannot deposit for the address zero");
       _balances[msg.sender] = _balances[msg.sender].add(_amount);
   }

   /**
     * @dev transfer 
     * Permet d'effectuer un transfert (virement)
    */
   function transfer(address _recipient, uint _amount) public{
       require(_recipient != address(0), "You cannot transfer to the address zero");
       require(_balances[msg.sender] >= _amount, "You have not enough balance");
       _balances[_recipient] = _balances[_recipient].add(_amount);
       _balances[msg.sender] = _balances[msg.sender].sub(_amount);
   }

   /**
     * @dev balanceOf  
     * Permet de consulter sa propre balance 
    */
   function balanceOf() public view returns (uint){
       return _balances[msg.sender];
   }
}
