To connect to Instances through the jump box

    ssh -i ~/.ssh/private-key -o "ProxyCommand ssh -W %h:%p -i ~/.ssh/private-key kearl@jumpHostIp" -o "StrictHostKeyChecking false" kearl@instanceIp
