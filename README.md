To connect to Instances through the jump box

    ssh -i ~/.ssh/private-key -o "ProxyCommand ssh -W %h:%p -i ~/.ssh/private-key kearl@jumpHostIp" -o "StrictHostKeyChecking false" kearl@instanceIp


nmap -Pn -p5100 --open 10.0.0.0/24 | grep "10.0.0" | awk '{ print $5 }' | xargs -I '$' sh -c 'echo "message1" | nc -w1 $ 5101'
netcat -l 5100 & netcat -l 5101 > blah.txt
