#!/bin/bash

if [ $# -ne 1 ]; then
    echo "USAGE: ${0} project";
    exit 0;
fi
pj="${1}";

fname='cn.postfix.txt';
wget https://ipv4.fetus.jp/${fname};

sed -e '/^#.*$/d' -e '/^$/d' -e 's/ *REJE.*$//g' -i ${fname};

cnt=256;
endLine=257;
idx=0;
while [ $(wc -l < ${fname}) -ne 0 ];
do    
    addrList=$(head -n ${cnt} ${fname} | tr '\n' ',' | sed 's/,$//g');
    idx=$((${idx}+1));

    gcloud compute --project=${pj} firewall-rules create chinaip-blocker-${idx} --direction=INGRESS --priority=${idx} --network=default --action=DENY --rules=all --source-ranges=${addrList};

    sed "1,${endLine}d" -i ${fname};
done
rm ${fname};
exit 0;