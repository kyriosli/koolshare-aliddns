#!/bin/sh

eval `dbus export aliddns_`

if [ "$aliddns_enable" != "1" ]; then
    exit
fi

now=`date`

ip=`curl http://whatismyip.akamai.com/ 2>/dev/null`
if [ "$ip" = "$aliddns_saved_ip" ]
then
    echo "skipping"
    dbus set aliddns_last_time=$now
    dbus set aliddns_last_act=skipped
    exit 0
fi

timestamp=`date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ"`

urlencode() {
    # urlencode <string>

    local length="${#1}"
    i=0
    out=""
    for i in $(awk "BEGIN { for ( i=0; i<$length; i++ ) { print i; } }")
    do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9._-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
        i=$(($i + 1))
    done
    echo -n $out
}

send_request() {
    local args="AccessKeyId=$aliddns_ak&Action=$1&Format=json&$2&Version=2015-01-09"
    local hash=$(urlencode $(echo -n "GET&%2F&$(urlencode $args)" | openssl dgst -sha1 -hmac "$aliddns_sk&" -binary | openssl base64))
    curl "http://alidns.aliyuncs.com/?$args&Signature=$hash" 2> /dev/null
}

get_recordid() {
    grep -Eo '"RecordId":"[0-9]+"' | cut -d':' -f2 | tr -d '"'
}

query_recordid() {
    send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$aliddns_name.$aliddns_domain&Timestamp=$timestamp"
}

update_record() {
    send_request "UpdateDomainRecord" "RR=$aliddns_name&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&Timestamp=$timestamp&Type=A&Value=$ip"
}

add_record() {
    send_request "AddDomainRecord&DomainName=$aliddns_domain" "RR=$aliddns_name&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&Timestamp=$timestamp&Type=A&Value=$ip"
}

if [[ "$aliddns_record_id" = "" ]]
then
    aliddns_record_id=`query_recordid | get_recordid`
    if [[ "$aliddns_record_id" = "" ]]
    then
        echo 'adding record'
        aliddns_record_id=`add_record | get_recordid`
    else
        echo 'updating record'
        update_record $aliddns_record_id
    fi
fi

# save to file
if [ "$aliddns_record_id" = "" ]; then
    # failed
    dbus ram aliddns_saved_ip=""
    dbus ram aliddns_last_act=failed
else
    dbus ram aliddns_record_id=$aliddns_record_id
    dbus ram aliddns_last_act="success: $ip"
    dbus ram aliddns_saved_ip=$ip
fi

dbus ram aliddns_last_time=$now