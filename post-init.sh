#!/bin/bash

# add default viewer user "user" if not created
count=$(/usr/bin/curl -s http://admin:${GF_SECURITY_ADMIN_PASSWORD}@localhost:3000/api/users/search?query=sseuser | jq '.totalCount')

if [ $count == "0" ]; then
	echo "creating default viewer user"
	/usr/bin/curl -s -X POST -H "Content-type: application/json" -d '{"login":"user","name":"Regular User","password":"anothersecret"}' http://admin:${GF_SECURITY_ADMIN_PASSWORD}@localhost:3000/api/admin/users
fi
