# Evaluation of Container Overlays for Secure Data Sharing
This repository includes the related codes for implementinb three different overlay setup methods according to container connectivity types (DDM connectivity, Request connectivity, and Group connectivity).

It includes the files that measure the throughput of each overlay setup by sending traffic between all pods of the requests and measuring the average throughput:

1. run-multiple.sh: This file determine how many requests with a sepecific overlay setup should be run at the same time and calls req-handling.sh
2. req-handling.sh: This file calls multiple createcontainer.sh at the same time according to the input from run-multiple.sh.
3. createcontainer.sh: This file creates containers of a request and run iperf between containers of that requests and the save the results of each iperf.
4. average.py : This file measure the average throughput of a specific number of requests that are ran at the same time on a speicific overlay setup.
