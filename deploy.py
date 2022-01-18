# Import solcx to compile our python code
from solcx import compile_standard, install_solc
import json
import os
from web3 import Web3, EthereumTesterProvider
from dotenv import load_dotenv

load_dotenv()

# Open, read and store the simpleStorage file as a variable.
with open("./simpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# Compile our solidity
install_solc("0.6.0")

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"simpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# we need the bytecode adn tge abi to deploy the file

# get bytecode
bytecode = compiled_sol["contracts"]["simpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = compiled_sol["contracts"]["simpleStorage.sol"]["SimpleStorage"]["abi"]

# for connecting to Ganache
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
chain_Id = 1337
my_address = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"
# In Python always add a 0x to the front of your private key.
# Python will look for the hexadeciaml version of the key
private_key = os.getenv("PRIVATE_KEY")

# Create the contract in Python
simple_storage = w3.eth.contract(abi=abi, bytecode=bytecode)

# get the latest transaction or nonce
nonce = w3.eth.getTransactionCount(my_address)

# 1. Build a transaction
# 2. Sign a transaction
# 3. Send a transaction

transaction = simple_storage.constructor().buildTransaction(
    {
        "chainId": chain_Id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce,
    }
)

# Sign Txn
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("Deploying Contract...")
# Send signed Txn
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

# Wait for transaction receipt
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Deployed!")

# Working with the contract you always need:
# Contract Address
# Contract ABI

# Create the contract
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# Call functions -> simulate making a call and getting a return value
# Transact  -> Actually makes a tate change

# interacting with the simple storage contract

# This is the initial value of the retrieve function
print(simple_storage.functions.retrieve().call())

# create a store function transaction
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_Id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,
    }
)
# sign store transaction
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

# send txn
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

print(simple_storage.functions.retrieve().call())
