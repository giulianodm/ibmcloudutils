#!/bin/sh
#title           :findservice.sh
#description     :Script to search for IBM Cloud platform services across all cloud foundry spaces within an organization 
#author		 :Giuliano Morais
#date            :20180117
#version         :0.1    
#usage		 :bash findService.sh YOUR_CF_ORG SERVICE-STRING-TO-FIND
#notes           :Install IBM bx cli tool as a pre-req
#==============================================================================


CF_ORG="$1"
SERVICE_TO_FIND="$2" 
printf "Searching for Service type containing * %s *\n" "$SERVICE_TO_FIND"

#remove the --sso parameter if your IBM Cloud account is not bound to an LDAP server
bx login --sso -a https://api.ng.bluemix.net -o $CF_ORG

declare -a resultados
resultados=("Space(s) found:")

for space in $(bx cf spaces | sed -e '1,5d')
do
    printf "Checking Space %s ..." "$space"
    bx target -s $space > /dev/null 2>&1;
    if bx cf services | grep -i $SERVICE_TO_FIND > /dev/null 2>&1; then
     resultados=("${resultados[@]}" $space)
	 printf 'Found in this space *****\n'     
	else
		printf "\n"
    fi
done
echo '---------------------------'

if [ ${#resultados[@]} -gt 1 ]; then
    echo ${resultados[@]}
else
    printf "The service %s wasn't found in the spaces from this cf org\n" "$SERVICE_TO_FIND" 
fi
echo '---------------------------'




