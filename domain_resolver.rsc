/system script
add dont-require-permissions=yes name=domain_resolver owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_Resolve domains/keywords and save IP or domain in address-list\
    \n# Version 1.0\
    \n\
    \n# Variables\
    \n#Array order: addrList,domain/keyword1,domain/keyword2,domain/keyword3,e\
    tc\
    \n:local dataArray {{\"netflix\";\"netflix\";\"nflxvideo\"};{\"windowsupda\
    te\";\"windowsupdate\";\"update.microsoft.com\";\"download.microsoft.com\"\
    ;\\\
    \n\"ntservicepack.microsoft.com\"};{\"teamviewer\";\"teamviewer\"}}\
    \n:local scriptName \"domain_resolver\"\
    \n:local logMsg\
    \n:local arrayLen\
    \n:local addrList\
    \n:local counter\
    \n:local keyWord\
    \n:local recordName\
    \n:local recordTtl\
    \n\
    \nif ([/system scheduler find where name=\"\$scriptName\"] = \"\") do={\
    \n    /system scheduler add name=\$scriptName start-time=startup interval=\
    5m start-date=Jan/01/1970 on-event=\$scriptName\
    \n}\
    \n\
    \n# Get arrayData data\
    \nif ([:len \$dataArray] = 0) do={\
    \n    :error message=\"dataArray empty!!!\"\
    \n} else={\
    \n    :set arrayLen ([:len \$dataArray] - 1);\
    \n    :put \"arrayLen= \$arrayLen\"\
    \n#Por cada una de las WAN dentro del array obtengo los datos y los proces\
    o\
    \nfor i from=0 to=\$arrayLen do={\
    \n    :set addrList (\$dataArray->\$i->0)\
    \n    :put \"addrList= \$addrList\"\
    \n    if ([:len (\$dataArray->\$i->1)] = 0) do={\
    \n        :error message=\"No domain o keyword set in dataArray!!! Please \
    put 1 or more!\"\
    \n    } else={\
    \n        :set counter 1;\
    \n        while ([:len (\$dataArray->\$i->\$counter)] !=0) do={\
    \n            :set keyWord (\$dataArray->\$i->\$counter)\
    \n            :put \"keyWord\$counter= \$keyWord\"\
    \n            :set counter (\$counter + 1)\
    \n            :foreach k in=[/ip dns cache all find where name~\"\$keyWord\
    \"] do={\
    \n                :set recordName [/ip dns cache all get \$k name];\
    \n                :set recordTtl [/ip dns cache all get \$k ttl];\
    \n                :delay 500ms\
    \n                :if (([:len \$recordName] != 0)) do={\
    \n                    :put \"recordName= \$recordName\"\
    \n                    :put \"recordTtl= \$recordTtl\"\
    \n                    :if ([/ip firewall address-list find where list=\$ad\
    drList && address=\$recordName] = \"\") do={ \
    \n                        :put \"Added entry: \$recordName to address-list\
    =\$addrList\"\
    \n                        if (\$recordTtl < \"00:05:00\") do={\
    \n                            set \$recordTtl \"00:05:00\"\
    \n                        }\
    \n                        /ip firewall address-list add address=\$recordNa\
    me list=\$addrList timeout=\$recordTtl;\
    \n                        delay 500ms\
    \n                    }\
    \n                } \
    \n            }\
    \n        }\
    \n    }\
    \n:put \"\"\
    \n}\
    \n}\
    \n"
