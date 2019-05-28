# montage_utils

Set of montage utilities for running older version of montage.

Some time ago, one of the servers hosting montage realated data switched over to https.
This action resulted in problems with running older versions of montage. Those older versions make direct (socket based) queries for data to mentioned service.
This problem can be solved by providing a proxy which strips https from requests and by directing montage at the proxy instead of the original url.

## Usage
Apply montage_localhost.patch to montage from: http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz, build, start the proxy (`python2 proxy.py`), run montage to create the dataset.

## montage_localhost.patch
This patch changes the destination host for all requests aimed at https://irsa.ipac.caltech.edu. After patching requests are directed at localhost.

## proxy.py
This simple python2 script acts as a proxy, which proxies http requests to https server.

## HyperFlow Montage tutorial
Tutorial is located here: https://github.com/hyperflow-wms/hyperflow/wiki/TutorialAMQP