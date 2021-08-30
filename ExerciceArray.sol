pragma solidity 0.6.11;

contract Whitelist {

  struct Person { // Structure de données
      string name;
      uint age;  
  }

  Person[] public persons;

  function add (string _name, uint age) public {
    Person memory person = Person(_name, age);
    persons.push(person);
  }

  function remove () public {
      persons.pop();
  }

}
