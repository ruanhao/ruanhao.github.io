#!/usr/bin/env bash
# -*- coding: utf-8 -*-

tempfoo=`basename $0`
tempfoo=${tempfoo%.*}
TMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1

cat <<EOF >$TMPFILE
@startuml

hide footbox

participant "snc_client (gen_server)" as snc_client
participant snc_encoder
participant snc_decoder
participant gen_tcp
database netconf_server


snc_client -> snc_encoder : Netconf RPC <<xmerl>>

snc_encoder -> gen_tcp    : Netconf RPC <<xml>>

gen_tcp -> netconf_server : send

netconf_server --> gen_tcp : receive

gen_tcp --> snc_decoder : Netconf RPC Reply <<xml>>

snc_decoder --> snc_client : Netconf RPC Reply <<xmerl>>

@enduml
EOF

java -jar ~/plantuml.jar -o `pwd` $TMPFILE
