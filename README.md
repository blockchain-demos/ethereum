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

![eth001](demo01/images/eth_demo01_python_bindings.jpg)





## demo01 - Reading Historical Data off of the blockchain
- Connect a Jupyter notebook to the live-net Ethereum Blockchain
- Retrieve Transaction History for a given block range
- Retrieve Smart Contract Execution Event Logs for a given block range
- Use a smart contract ABI to load the schema for that contract's event logs


## demo02 - Consuming live data from new blocks 
- Create a Web3 Topic Listener for 1 contract's invocations in a new block
- Create a Kafka Topic outputting ALL Events in a new block

---

## Background

When most people think of "Blockchain", they think about Alice Sending Bob 2 coins, and that transaction being recorded on a public ledger.

On the ethereum chain however, the public ledger holds both currency transfers AND code (Smart Contract) execution logs.



### Not all HelloWorld are the same

In a traditional object oriented language, running a "HelloWorld.exension" should result in the same output whether Alice runs the file or Bob runs the file.

On the ethereum blockchain, when a program is written, it must be "deployed" to the blockchain by a user's wallet. This means that although 2 ".sol" programs may have 100% identical code, they will each by pushed to the blockchain and have a unique "Contract Address", along with some metadata such as the user who deployed the contract.

Here we will use remix.ethereum.org, a free Solidity Web Compiler, to showcase a simple Hello World smart contract deployed by Alice vs Hello World Deployed by Bobbie

- HelloWorld.sol deployed by alice's wallet `0xca35b7d915458ef540ade6068dfe2f44e8fa733c`:
  - <img src="https://user-images.githubusercontent.com/9003246/36337223-91e5f504-1346-11e8-9832-3e6852eef631.png" width="350">


- HelloWorld.sol deployed by Bob's wallet `0x14723a09acff6d2a60dcdf7aa4aff308fddc160c`:
 - <img src="https://user-images.githubusercontent.com/9003246/36337235-b64e358c-1346-11e8-90c2-29a27b0c15f5.png" width="350">


Even more interesting, once a "smart contract" is deployed to a "contract address", EACH FUNCTION in the smart contract has a unique "MethodID" and "Topic" which can be used to see when that given function belonging to the smart contract was invoked.



