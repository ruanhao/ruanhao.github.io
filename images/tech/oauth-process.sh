#!/usr/bin/env bash
# -*- coding: utf-8 -*-

tempfoo=`basename $0`
tempfoo=${tempfoo%.*}
TMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1

cat <<EOF >$TMPFILE
@startuml

hide footbox
skinparam handwritten true

skinparam sequence {
    ActorFontSize 30
    ParticipantFontSize 30
    ArrowFontSize 28
    DividerFontSize 30
    ArrowThickness 2
}

actor 用户 as user
participant 点评客户端 as dp
participant 微信 as wx

||50||
== Step 1 - User Shows Intent ==
|||
user -> dp : 请帮我把这篇点评发到微信朋友圈
|||
dp --> user : 好的，包在我身上

||100||

== Step 2 - Consumer Gets Permission ==
|||
dp -> wx : 有个用户想让我帮他发个朋友圈，能给我个 request token 吗？
|||
wx --> dp : 好的，给，这是 token 和 secret

||100||

== Step 3 - User Is Redirected to Service Provider ==
|||
dp -> user : 先去微信那里确认下吧，带好这个 token 哦

||100||

== Step 4 - User Gives Permission ==
|||
user -> wx : 刚才点评给了我这个 token ，我想对它授权
|||
wx -> user : 你确定授权点评在你的朋友圈中发布这篇文章？
|||
user --> wx : 是的
|||
wx --> user : 好嘞，你可以告诉点评他已经有权限使用这个 request token 了

||100||

== Step 5 - Consumer Obtains an Access Token ==
|||
dp -> wx : 帮我把这个 request token 换成 access token 吧
|||
wx --> dp : 没问题，这是你的 access token 和 secret

||100||

== Step 6 - Consumer Accesses the Protected Resource ==
|||
dp -> wx : 我要帮用户发布一则朋友圈，这是我的 access token
|||
wx --> dp : 搞定

@enduml
EOF

java -jar ~/plantuml.jar -o `pwd` $TMPFILE
