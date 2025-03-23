# Solidity Contracts - Registrar & MultiSigWallet

This repository contains two Solidity smart contracts:

1. **Registrar Contract**: A simple registration system that allows an approver to register users by paying a fee.
2. **MultiSigWallet Contract**: A multi-signature wallet system where multiple signers approve transactions before execution.

## Contracts

### 1. **Registrar Contract**

The `Registrar` contract is designed to allow a designated **approver** to register addresses by accepting a specified amount of ether.

#### Key Features:

- **Registration**: Only the approver can register a user with a minimum ether payment.
- **Tracking Registrants**: The contract keeps track of all registered users' addresses.
- **Approver Validation**: The contract only allows one authorized address (approver) to initiate registrations.

#### Functions:

- `register(address _registrant)` - Registers a user by the approver with a fee of 1000 wei.
- `getRegistrants()` - Returns a list of all registered addresses.

### 2. **MultiSigWallet Contract**

The `MultiSigWallet` contract allows multiple signers to approve a transaction before it can be executed. It ensures a higher level of security and control over funds.

#### Key Features:

- **Multiple Signers**: Multiple signers can approve transactions, providing redundancy and security.
- **Transaction Approval**: A transaction needs a predefined number of signers to approve before it can be executed.
- **Registrar Integration**: The wallet can call the `Registrar` contract for registration purposes after the transaction is approved.

#### Functions:

- `setRegistrar(address _registrar)` - Sets the registrar contract address.
- `submitTransaction(address _to, uint256 _value, bytes memory _data)` - Submits a new transaction for approval.
- `approve(uint256 _txId)` - Allows a signer to approve a transaction.
- `executeTransaction(uint256 _txId)` - Executes a transaction once the required approvals are met.

## Prerequisites

- **Solidity**: Version 0.8.4 and 0.8.0 for respective contracts.
- **Ethereum Wallet**: For interacting with the contracts and paying gas fees.
- **Remix IDE**: For compiling and deploying smart contracts easily.

## Deployment Instructions

1. **Deploy the Registrar Contract**:

   - Deploy the `Registrar` contract by providing an **approver** address.
   - This address will be able to call the `register` function to register other addresses.

2. **Deploy the MultiSigWallet Contract**:

   - Deploy the `MultiSigWallet` contract with a list of **signer** addresses and a **required** number of approvals.
   - After deployment, call `setRegistrar(address _registrar)` to link it to the deployed `Registrar` contract.

3. **Interacting with Contracts**:
   - The approver can call the `register()` function on the `Registrar` contract to register addresses.
   - Signers of the `MultiSigWallet` can submit, approve, and execute transactions after meeting the approval criteria.

## Usage Example

### Register a User:

- The **approver** calls the `register` function on the `Registrar` contract to register an address.

### Submit a Transaction:

- A signer submits a transaction to the `MultiSigWallet` using the `submitTransaction()` function.

### Approve a Transaction:

- Each signer can approve the transaction by calling the `approve()` function.

### Execute a Transaction:

- Once the required number of approvals is reached, the transaction can be executed by any signer using the `executeTransaction()` function.

## Events

Both contracts emit important events to track key actions:

- **Registrar Contract**:

  - `Registered(address registrant)` - Triggered when a user is successfully registered.

- **MultiSigWallet Contract**:
  - `TransactionSubmitted(uint256 txId, address sender)` - Triggered when a transaction is submitted.
  - `TransactionApproved(uint256 txId, address approver)` - Triggered when a signer approves a transaction.
  - `TransactionExecuted(uint256 txId)` - Triggered when a transaction is executed.
  - `RegistrarSet(address registrar)` - Triggered when a registrar contract address is set.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to fork and contribute to the project!
