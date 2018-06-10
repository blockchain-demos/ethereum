# Ethereum Blockchain Demos
Collection of demos for interacting with the Ethereum Blockchain

**Pre-reqs**: To access the Ethereum Blockchain, we'll be using geth, the official Go Ethereum CLI client. It is the entry point into the Ethereum network (main-, test- or private net), capable of running as a full node (default) archive node (retaining all historical state) or a light node (retrieving data live).

Starting a ethereum/client-go container:
```
docker pull ethereum/client-go:v1.8.3

docker run -d --name ethereum-node \
-p 8545:8545 -p 30303:30303 \
ethereum/client-go:v1.8.3 \
--syncmode light \
--rpc --rpcaddr 0.0.0.0
```

This allows you to view and query events from the blockchain locally via a number of tools/bindings:

- **cUrl**

  ```
  curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' -X POST http://localhost:8545

  {"jsonrpc":"2.0","id":83,"result":"0x51ed3f"}

  ```

- **python web3**

  ```
  from web3 import Web3, HTTPProvider, IPCProvider
  web3 = Web3(HTTPProvider('http://localhost:8545'))

  # Retrieve the last block number available from geth RPC
  currentblock = web3.eth.getBlock('latest').number
  ```

# Demos

- [01_Intro](./01_Intro_to_web3/Part1_Intro_To_Web3_Python.ipynb) - Basic Introduction to interacting with ethereum chain from a jupyter notebook
- [02_Retrieving Smart Contract Logs](./02_Retrieving_and_Parsing_Smart_Contract_Events/Parsing_Smart_Contract_Events.ipynb) - Query and parse transactions to find those which include smart contract events.
- [03_Streaming Events to Kafka](./Eth_Events_in_Streaming_Apps/Remote_Eth_TransactionLogs_Producer.ipynb) - Retrieve Transaction Logs and produce to a kafka topic

---

## Background

When most people think of "Blockchain", they think about Alice Sending Bob 2 coins, and that transaction being recorded on a public ledger.

On the Ethereum chain however, the public ledger holds both currency transfers AND code (Smart Contract) execution logs.



### Not all HelloWorld are the same

In a traditional object oriented language, running a "HelloWorld.exension" should result in the same output whether Alice runs the file or Bob runs the file.

On the ethereum blockchain, when a program is written, it must be "deployed" to the blockchain by a user's wallet. This means that although 2 ".sol" programs may have 100% identical code, they will each by pushed to the blockchain and have a unique "Contract Address", along with some metadata such as the user who deployed the contract.

Here we will use remix.ethereum.org, a free Solidity Web Compiler, to showcase a simple Hello World smart contract deployed by Alice vs Hello World Deployed by Bobbie

- HelloWorld.sol deployed by alice's wallet `0xca35b7d915458ef540ade6068dfe2f44e8fa733c`:
  - <img src="https://user-images.githubusercontent.com/9003246/36337223-91e5f504-1346-11e8-9832-3e6852eef631.png" width="350">


- HelloWorld.sol deployed by Bob's wallet `0x14723a09acff6d2a60dcdf7aa4aff308fddc160c`:
 - <img src="https://user-images.githubusercontent.com/9003246/36337235-b64e358c-1346-11e8-90c2-29a27b0c15f5.png" width="350">


Even more interesting, once a "smart contract" is deployed to a "contract address", EACH FUNCTION in the smart contract has a unique "MethodID" and "Topic" which can be used to see when that given function belonging to the smart contract was invoked.
