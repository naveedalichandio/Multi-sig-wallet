//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Registrar {
    address[] private registrantsAddress;
    address public approver;

    mapping(address=> bool) public registered;


    constructor(address _approver){
        require(_approver != address(0), "Please give an approver!");
       approver = _approver;
    }

    modifier isRegistered(address _registrant){
        require(!registered[_registrant],"Already registered!");
        _;
    }

    function register(address _registrant)external isRegistered(_registrant) payable  returns (string memory message){
        require(msg.sender == approver, "Not authorized");
        require(msg.value >=1000, "Please send minimum 1000 wei");
        require(_registrant != address(0));  
         registrantsAddress.push(_registrant);
         registered[_registrant] = true;
         return("Registered!");
    }

    function getRegistrants() view external returns(address[] memory){
        return (registrantsAddress);
    }


}