
Part 1 - demonstrated how to retrieve metadata about new blocks detected on the ethereum chain.

Now let's look at retrieving block metadata and transactions in bulk

# Import ethereum tools and test connection
web3 is a python library for interacting with Ethereum http://web3py.readthedocs.io/en/stable/


```python
from web3 import Web3, HTTPProvider, IPCProvider

gethRPCUrl='http://localhost:8545'
web3 = Web3(HTTPProvider(gethRPCUrl))

# Retrieve the last block number available from geth RPC
currentblock = web3.eth.getBlock('latest').number
print("Latest block: " + str(currentblock))
```

    Latest block: 5616180


### Create some methods to retrieve blocks and transactions as a json
**getBlockRange** 
- Returns a JSON with all block metadata in block range

**getTransactionsInRange** 
- Returns a JSON with all Transactions in block range


![eventlogs](https://github.com/blockchain-demos/ethereum/blob/master/02_Retrieving_and_Parsing_Smart_Contract_Events/image.png?raw=true)

**getEventsInRange** - Given a block range,
- Return all Event Logs for any transactions which produced them



```python
from hexbytes import HexBytes
def getBlockRange(blockstart,blockend):
    blocksDict = [ ]  
    for block in range(blockstart,blockend):  
        blocksDict.append(dict(web3.eth.getBlock(block,full_transactions=False)))
    return blocksDict

def getTransactionsInRange(blockstart,blockend):
    transactions_in_range=[]
    for block in range(blockstart,blockend):       
        transactions_in_block = web3.eth.getBlock(block,full_transactions=True)['transactions']       
        for transaction in transactions_in_block:
            cleansesed_transactions=(dict(transaction))
            cleansesed_transactions['blockHash'] = HexBytes(transaction['blockHash']).hex()
            cleansesed_transactions['hash'] = HexBytes(transaction['hash']).hex()
            transactions_in_range.append(cleansesed_transactions)
    return transactions_in_range
```


```python
TXS_IN_RANGE=getTransactionsInRange(currentblock-1,currentblock)
```


```python
TXS_IN_RANGE[0]
```




    {'blockHash': '0x007b1d77a3e7a9a6f44611e77387572285b9dc91a527587f8411fd063afa9703',
     'blockNumber': 5616179,
     'chainId': '0x1',
     'condition': None,
     'creates': None,
     'from': '0x390dE26d772D2e2005C6d1d24afC902bae37a4bB',
     'gas': 45000,
     'gasPrice': 118000000000,
     'hash': '0x57d08d537a5db7a39816178f7c758efb316b324f18d5b3876cb0c8a55ca6c70e',
     'input': '0x',
     'nonce': 400044,
     'publicKey': HexBytes('0xa9521966b91992bfa5f5ef494f4891a8b9166f667d9b994ec36942c9523c5ed00890ff5c56e9d6a897b79614c9f0a98b7b731c39adcd7b51902b1a5272d3269f'),
     'r': HexBytes('0x9aba7d5068000c7e884777045d05ba1f6d4090b5ac2ba1ff8d18e1977d99ebfb'),
     'raw': HexBytes('0xf86f83061aac851b79591c0082afc894e4e6addc635e9d1280ff7568d7be5f7eff14c549881bc16d674ec800008025a09aba7d5068000c7e884777045d05ba1f6d4090b5ac2ba1ff8d18e1977d99ebfba051e5fbb98ede0661bd16a2366142bebc70a5edadc4586014bf0d84392c9eda81'),
     's': HexBytes('0x51e5fbb98ede0661bd16a2366142bebc70a5edadc4586014bf0d84392c9eda81'),
     'standardV': 0,
     'to': '0xe4E6aDDc635e9D1280FF7568d7BE5F7efF14c549',
     'transactionIndex': 0,
     'v': 37,
     'value': 2000000000000000000}



---
A **Smart Contract Code Execution** is recorded as a transaction, with the output of the smart contract method in the `logs[]`. Note, not all transactions will include `logs[]` on the ethereum chain.

Lets create a new method:

**getAllEventLogs** - Returns a JSON with all transactions including Event Logs for a given block range

- NOTE: Web3 Returns `HexBytes` and `AtrributeDict` data types. Lets sanitize the response such that it can be used in kafka/hbase/hive




```python
def getAllEventLogs(blockstart,blockend):
    tx_event_logs = [ ]
    for transaction in getTransactionsInRange(blockstart,blockend):
        tx_event=dict(web3.eth.getTransactionReceipt(transaction_hash=transaction['hash']))
        if(tx_event is not None):
            if(tx_event['logs'] is not None and tx_event['logs']):
                # Create a new santized_logs json
                santized_logs = [ ]
                for event_log in tx_event['logs']:
                    # AttributeDict -> Dict
                    santized_logs.append(dict(event_log))
                tx_event['logs'] = santized_logs
                # HexBytes -> String
                tx_event['transactionHash'] = HexBytes(tx_event['transactionHash']).hex()
            
                tx_event_logs.append(dict(tx_event))
    return tx_event_logs
```


```python
EVENTS_WITH_LOGS=getAllEventLogs(currentblock-1,currentblock)
```


```python
# Sample event with 1 method producing logs

EVENTS_WITH_LOGS[0]
```




    {'blockHash': HexBytes('0x007b1d77a3e7a9a6f44611e77387572285b9dc91a527587f8411fd063afa9703'),
     'blockNumber': 5616179,
     'contractAddress': None,
     'cumulativeGasUsed': 79769,
     'gasUsed': None,
     'logs': [{'address': '0x57aD67aCf9bF015E4820Fbd66EA1A21BED8852eC',
       'blockHash': None,
       'blockNumber': None,
       'data': '0x0000000000000000000000000000000000000000000000d7e8740a38a1c80000',
       'logIndex': None,
       'topics': [HexBytes('0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'),
        HexBytes('0x000000000000000000000000de1c5965c23b7ace63d300a3148b0a085ece75c8'),
        HexBytes('0x000000000000000000000000aa11c157d4f97da9b0326f7b0a8533ea31962bc8')],
       'transactionHash': None,
       'transactionIndex': None,
       'transactionLogIndex': None,
       'type': 'pending'}],
     'logsBloom': HexBytes('0x00000000000000000000000000000000000800000000000000000000000000000000400000000000000000000000000000000000000000008000080000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000400000000000000000000000000000020000010000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000'),
     'root': None,
     'status': 1,
     'transactionHash': '0x349cce2a100003b7ca1d20eae66a1d488343ed5c5083658f37e788ad57a2563c',
     'transactionIndex': 2}




```python
# Sample event with 2 method invocations within 1 contract, producing logs[] length 2.
EVENTS_WITH_LOGS[2]
```




    {'blockHash': HexBytes('0x007b1d77a3e7a9a6f44611e77387572285b9dc91a527587f8411fd063afa9703'),
     'blockNumber': 5616179,
     'contractAddress': None,
     'cumulativeGasUsed': 172853,
     'gasUsed': None,
     'logs': [{'address': '0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0',
       'blockHash': None,
       'blockNumber': None,
       'data': '0x000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000044a9059cbb000000000000000000000000c5f43be0e3d4e33002ae10683369a6fb787ccd530000000000000000000000000000000000000000000000104356506b6063f400',
       'logIndex': None,
       'topics': [HexBytes('0xa9059cbb00000000000000000000000000000000000000000000000000000000'),
        HexBytes('0x00000000000000000000000083761c6785427f5a27a07c92a9dcfa99947bc4ad'),
        HexBytes('0x000000000000000000000000c5f43be0e3d4e33002ae10683369a6fb787ccd53'),
        HexBytes('0x0000000000000000000000000000000000000000000000104356506b6063f400')],
       'transactionHash': None,
       'transactionIndex': None,
       'transactionLogIndex': None,
       'type': 'pending'},
      {'address': '0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0',
       'blockHash': None,
       'blockNumber': None,
       'data': '0x0000000000000000000000000000000000000000000000104356506b6063f400',
       'logIndex': None,
       'topics': [HexBytes('0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'),
        HexBytes('0x00000000000000000000000083761c6785427f5a27a07c92a9dcfa99947bc4ad'),
        HexBytes('0x000000000000000000000000c5f43be0e3d4e33002ae10683369a6fb787ccd53')],
       'transactionHash': None,
       'transactionIndex': None,
       'transactionLogIndex': None,
       'type': 'pending'}],
     'logsBloom': HexBytes('0x00000000000000000000000000000080000140000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000104008000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000010000000002000000000000000000000000000000000000000000000100000000000000000000000000000000000000004000040000000000100000000000000000000000000000002000000000000000000000000000800000000000000000002000000000000000000000000000000000000200000000000000000000000000000000000'),
     'root': None,
     'status': 1,
     'transactionHash': '0xf8a05bbc98524d61a6d53261cb7a474672aaf7b0dd678455b118c30789af791a',
     'transactionIndex': 4}


