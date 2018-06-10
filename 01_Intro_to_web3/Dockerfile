FROM python:3.6

ARG NB_USER=demo

RUN useradd -m -s /bin/bash -N $NB_USER
RUN apt-get update && apt-get install -y libssl-dev

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN mkdir /Notebooks
RUN chown $NB_USER /Notebooks

COPY dockerscripts/start-nb.sh /usr/local/bin/
RUN chown $NB_USER /usr/local/bin/start-nb.sh

USER $NB_USER
WORKDIR /Notebooks


CMD ["sh", "/usr/local/bin/start-nb.sh"]