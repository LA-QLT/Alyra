
pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20{
    
    constructor(string memory name_, string memory symbol_) ERC20("efs","e"){
        
    }
    
}