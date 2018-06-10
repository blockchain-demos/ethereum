#!/bin/sh

jupyter lab \
--NotebookApp.ip=0.0.0.0 \
--NotebookApp.token='ethdemos' \
--NotebookApp.iopub_msg_rate_limit=10000 \
--NotebookApp.port=8895 \
--FileManagerMixin.use_atomic_writing=False