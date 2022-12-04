#!/bin/bash

cat > index.html <<EOF
<h1>"Hi there, big fella"</h1>
<h2>"Did you know that you can write whatever you want on the internet?"</h2>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &