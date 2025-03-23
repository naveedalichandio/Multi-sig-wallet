
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {

    address public  registrar;

    address[] public signers;
    uint256 required;
    
    
    mapping (uint256 => uint256) public signedBy;
    mapping(address => bool) public isSigner;
    mapping (uint256 => mapping( address => bool)) public hasSigned;

    struct Transaction{
        address to;
        uint256 value;
        bytes data;
        address sender;
    }

    Transaction[] public transactions;


    event TransactionSubmitted(uint256 txId, address sender);
    event TransactionApproved(uint256 txId, address approver);
    event TransactionExecuted(uint256 txId);
    event RegistrarSet(address registrar);

    modifier checkIfSigner(address _signer){
        require(isSigner[_signer] == true,"Invalid signers");
        _;
    }

    modifier checkIfSigned(uint256 _txId){
        require(!hasSigned[_txId][msg.sender], "Already signed!");
        _;
    }

    modifier checkIfExist(uint256 _txId){
        require(_txId < transactions.length, "Invalid transaction");
        _;
    }

    modifier isApproved(uint256 _txId){
            signedBy[_txId] >= required;
        _;
    }

    modifier onlyOwner(){
        require(isSigner[msg.sender], "Invalid caller");
        _;
    }


    constructor(address[] memory _signers, uint256 _required){

        require(_signers.length > 0, "Signers required");
        require(_required > 0 && _required <= _signers.length, "Invalid required approvals");

        for (uint i = 0; i < _signers.length; ++i) {
            require(_signers[i] != address(0), "Invalid signer address");
            require(!isSigner[_signers[i]], "Signer already added");

            signers.push(_signers[i]);
            isSigner[_signers[i]] = true;
        }
        required = _required;
    }

    function setRegistrar(address _registrar)external onlyOwner{
        require(_registrar != address(0), "Invalid registrar");

        registrar = _registrar;

        emit RegistrarSet(_registrar);
    }

    function submitTransaction(address _to, uint256 _value, bytes memory _data)payable  public {
        require(msg.value >= 1 ether, "Not enough ether");
        transactions.push(Transaction(_to, _value, _data, msg.sender));
    }

    function approve(uint256 _txId)public checkIfExist(_txId)  checkIfSigned(_txId) checkIfSigner(msg.sender){
        hasSigned[_txId][msg.sender] = true;
        signedBy[_txId] +=1;
        emit TransactionApproved(_txId, msg.sender);
    }

    function executeTransaction(uint256 _txId)public checkIfExist(_txId) isApproved(_txId){
        require(isSigner[msg.sender], "Not a signers");
        require(registrar != address(0), "registrar address not set!");
        Transaction storage transaction = transactions[_txId];
        (bool success, )=registrar.call{value: transaction.value}(abi.encodeWithSignature("register(address)", transaction.to));

        require(success, "Failed");
    }
}