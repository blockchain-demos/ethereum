# Reading events off of the eth blockchain

**Pre-reqs:**
To access the Ethereum Blockchain, we'll be using **geth**, the official Go Ethereum CLI client. It is the entry point into the Ethereum network (main-, test- or private net), capable of running as a full node (default) archive node (retaining all historical state) or a light node (retrieving data live).

Starting a ethereum/client-go container:
```
docker pull ethereum/client-go:v1.8.3

docker run -d --name ethereum-node \
-p 8545:8545 -p 30303:30303 \
ethereum/client-go:v1.8.3 \
--syncmode light \
--rpc --rpcaddr 0.0.0.0
```

---

## Notebook Demos

### Option 1 - Run the notebooks with Virtual Environments
```
# 1. Install conda/miniconda 
wget -P /tmp/ https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Silent Install to prefix=/opt/miniconda3/ 
bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -f -p /opt/miniconda3/

# 2. Create virtual env with blockchain demos packages
conda create -n eth_demo_env python=3.5
source activate eth_demo_env
pip install -r <git source>/series01-eth_blockchain/demo01/requirements.txt


# 3. Start a notebook
jupyter notebook --NotebookApp.ip=0.0.0.0 \
--NotebookApp.token='yourpass' \
--NotebookApp.port=8895
```
Connect to the notebook via http://<yourhost>:8895 , using the token you set - `yourpass`


### Option 2 - Run the notebook and virtual envs in a docker container
```
# 1. Build the docker image
cd <git source>/series01-eth_blockchain/demo01/
docker build -t ethdemo01 .

# 2. Start the docker container
docker run -it --rm \
--name ethdemo01notebook \
-v $(pwd):/Notebooks \
-p 8895:8895 ethdemo01
```
Connect to the notebook via http://<yourhost>:8895 , using the token - `ethdemos`



