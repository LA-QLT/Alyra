pragma solidity 0.6.11;



contract Whitetlist {


    struct Person {
        string name;
        uint age;
    }

    Person [] public people; 
    
    function addPerson(string _name, uint _age){
        Person memory personne = Person(_name, _age);
    }
}
