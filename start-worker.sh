#! /bin/bash -x

netcat -l 5100 & netcat -l 5101 > cluster-token.txt