#!/bin/bash

version=1.0.0

#cli help function
helpFunction()
{
  echo ""
  echo -e "$(tput bold)$(tput setaf 3)This script will setup and deploy part 2 of the platfom services and configuration\nfrom the Git repository on this machine.\nIMPORTANT: This script should be run ONLY AFTER successful execution of \"setup-part1.sh\" script.$(tput sgr 0)\n"
  echo -e "Usage: $0 --domain '<domain-name>' --api-key '<api-key>' --token '<admin-auth-token>'\n\t\t\t--bae-paypal-id '<bae-paypal-id>' --bae-paypal-secret '<bae-paypal-secret>' --stack '<swarm-stack-name>'\n"
  echo -e "Mandatory options:"
  echo -e "\t--domain\t\tdomain name (MUST be the same value as in first setup script!)"
  echo -e "\t--api-key\t\tAPI Key of the first created Umbrella user"
  echo -e "\t--token\t\t\tAdmin API Token of the first created Umbrella admin"
  echo -e "\t--stack\t\t\tstack name for the Docker Swarm - can be chosen freely and will be used as name prefix for Docker container and networks (MUST be the same value as in first setup script!)\n"
  echo -e "Optional options:"
  echo -e "\t--bae-paypal-id\t\tPayPal client ID to be used when using PayPal as payment gateway in BAE Marketplace"
  echo -e "\t--bae-paypal-secret\tPayPal client secret"
  echo -e "\t--version\t\tprints out the script's version"
  echo -e "\t--help\t\t\tprints out these help and usage information\n"
  echo -e "$(tput bold)$(tput setaf 5)Report bugs to: chandra.challagonda@fiware.org$(tput sgr 0)"
  echo -e "$(tput bold)$(tput setaf 5)License: AGPL-3.0, (c) 2020-2021 FIWARE Foundation$(tput sgr 0)"
  echo -e "\n"
  exit 0
}

while (( $# > 0 ))
do
  opt="$1"
  shift
  case $opt in
  --help)
    helpFunction
    exit 0
    ;;
  --version)
    echo -e "$(tput bold)$(tput setaf 3)$version$(tput sgr 0)"
    exit 0
    ;;
  --domain)
    DOMAIN="$1"
    shift
    ;;
  --api-key)
    API_KEY="$1"
    shift
    ;;
  --token)
    TOKEN="$1"
    shift
    ;;
  --bae-paypal-id)
    BAE_PAYPAL_ID="$1"
    shift
    ;;
  --bae-paypal-secret)
    BAE_PAYPAL_SECRET="$1"
    shift
    ;;
  --stack)
    STACK="$1"
    shift
    ;;
  *)
    echo -e "$(tput bold)$(tput setaf 1)Usage: $0 [OPTIONS]...\nTry '$0 --help' for more information.$(tput sgr 0)"
    exit 1;
    ;;
  esac
done

if [ -z "${DOMAIN}" ] || [ -z "${API_KEY}" ] || [ -z "${TOKEN}" ] || [ -z "${STACK}" ]
then
  echo -e "$(tput bold)$(tput setaf 1)Missing one of the mandatory options$(tput sgr 0)"
  echo -e "$(tput bold)$(tput setaf 2)Usage: $0 [OPTIONS]...\nTry '$0 --help' for more information.$(tput sgr 0)"
  exit 1
fi

#Pre-requisites
IDM_USERID="admin"
IDM_EMAIL="admin@test.com"
IDM_PWD="1234"
#If PayPal API credentials not given, leave variable name as value
BAE_PAYPAL_ID=${BAE_PAYPAL_ID:-BAE_PAYPAL_ID}
BAE_PAYPAL_SECRET=${BAE_PAYPAL_SECRET:-BAE_PAYPAL_SECRET}

echo -e "\nReplacing UMBRELLA_KEY and UMBRELLA_TOKEN in the repo files"
grep -rl 'UMBRELLA_KEY' * --exclude-dir scripts | xargs sed -i "s|UMBRELLA_KEY|${API_KEY}|g"
grep -rl 'UMBRELLA_TOKEN' * --exclude-dir scripts | xargs sed -i "s|UMBRELLA_TOKEN|${TOKEN}|g"

#Adding website backends in Umbrella
echo -e "$(tput bold)$(tput setaf 3)\n\nAdding website backends in Umbrella...$(tput sgr 0)"
frontend_host=(${DOMAIN} accounts.${DOMAIN} apis.${DOMAIN} market.${DOMAIN} umbrella.${DOMAIN})
backend_server=(nginx keyrock apinf bae nginx)
backend_protocol=(80 3000 3000 8004 80)

for (( i=0; i<${#frontend_host[@]}; i++ )) do
  for j in ${backend_server[$i]}; do
    for k in ${backend_protocol[$i]}; do
      echo -e "\nAdding website backend for the domain ${frontend_host[$i]} $j $k"
      website_backend_id=$(curl -s -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{ \
        \"website_backend\": { \
          \"frontend_host\": \"${frontend_host[$i]}\", \
          \"backend_protocol\": \"http\", \
          \"server_host\": \"$j\", \
          \"server_port\": $k \
        } \
      }" "https://umbrella.${DOMAIN}/api-umbrella/v1/website_backends.json" \
      -H "X-Api-Key: ${API_KEY}" \
      -H "X-Admin-Auth-Token: ${TOKEN}"|python -mjson.tool|grep '"id":'|awk -F": " '{print $2}'|tr -d '",\r')
      echo -e "publishing changes for the domain ${frontend_host[$i]}"
      curl -s -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{ \
        \"config\": { \
          \"website_backends\": { \
            \"${website_backend_id}\": { \
              \"publish\": \"1\" \
            } \
          } \
        } \
      }" "https://umbrella.${DOMAIN}/api-umbrella/v1/config/publish.json" \
      -H "X-Api-Key: ${API_KEY}" \
      -H "X-Admin-Auth-Token: ${TOKEN}"
    done
  done
done
echo -e "$(tput bold)$(tput setaf 5)\nSuccessfully added website backends in Umbrella$(tput sgr 0)"

#Adding applications to IDM and replace dummy clientid and secret for applications
sleep 5
echo -e "$(tput bold)$(tput setaf 3)\n\nAdding applications to IDM...$(tput sgr 0)"
idm_token=$(curl -s --include \
                  --request POST \
                  --header "Content-Type: application/json" \
                  --data-binary "{
                    \"name\": \"${IDM_EMAIL}\",
                    \"password\": \"${IDM_PWD}\"
                  }" \
                  "https://accounts.${DOMAIN}/v1/auth/tokens"|grep "x-subject-token"|awk -F": " '{print $2}'|tr -d '\r')

echo -e "\nAdding IDM application 'API Catalogue'"
app2_id=$(curl -s \
              --request POST \
              --header "Content-Type: application/json" \
              --header "X-Auth-token: ${idm_token}" \
              --data-binary "{
                \"application\": {
                  \"name\": \"API Catalogue\",
                  \"description\": \"Catalogue of APIs provided using Profirator API Management Platform\",
                  \"url\": \"https://apis.${DOMAIN}\",
                  \"redirect_uri\": \"https://apis.${DOMAIN}/_oauth/fiware\",
                  \"grant_type\": [
                    \"authorization_code\",
                    \"implicit\",
                    \"password\"
                  ],
                  \"token_types\": [
                    \"jwt\",
                    \"permanent\"
                  ]
                }
              }" \
          "https://accounts.${DOMAIN}/v1/applications"|python -mjson.tool|grep '"id":'|awk -F": " '{print $2}'|tr -d '",\r')
echo -e "Getting application's secret"
app2_secret=$(curl -s \
                  --header "X-Auth-token: ${idm_token}" \
              "https://accounts.${DOMAIN}/v1/applications/${app2_id}"|python -mjson.tool|grep '"secret":'|awk -F": " '{print $2}'|tr -d '",\r')
echo -e "Adding roles"
app2_roles=(tenant-admin data-provider data-consumer)
for (( i=0; i<${#app2_roles[@]}; i++ )) do
  curl -s \
        --request POST \
        --header "Content-Type: application/json" \
        --header "X-Auth-token: ${idm_token}" \
        --data-binary "{
          \"role\": {
            \"name\": \"${app2_roles[$i]}\"
          }
        }" \
  "https://accounts.${DOMAIN}/v1/applications/${app2_id}/roles"
done
echo "\nReplacing API_CATALOGUE_ID and API_CATALOGUE_SECRET in the repo files"
grep -rl 'API_CATALOGUE_ID' * --exclude-dir scripts | xargs sed -i "s|API_CATALOGUE_ID|${app2_id}|g"
grep -rl 'API_CATALOGUE_SECRET' * --exclude-dir scripts | xargs sed -i "s|API_CATALOGUE_SECRET|${app2_secret}|g"

echo -e "\nAdding IDM application 'BAE'"
app4_id=$(curl -s \
              --request POST \
              --header "Content-Type: application/json" \
              --header "X-Auth-token: ${idm_token}" \
              --data-binary "{
                \"application\": {
                  \"name\": \"Market\",
                  \"description\": \"Market service provided by the Business API Ecosystem\",
                  \"url\": \"https://market.${DOMAIN}\",
                  \"redirect_uri\": \"https://market.${DOMAIN}/auth/fiware/callback\",
                  \"grant_type\": [
                    \"authorization_code\",
                    \"implicit\",
                    \"password\"
                  ]
                }
              }" \
          "https://accounts.${DOMAIN}/v1/applications"|python -mjson.tool|grep '"id":'|awk -F": " '{print $2}'|tr -d '",\r')
echo -e "Getting application's secret"
app4_secret=$(curl -s \
                  --header "X-Auth-token: ${idm_token}" \
              "https://accounts.${DOMAIN}/v1/applications/${app4_id}"|python -mjson.tool|grep '"secret":'|awk -F": " '{print $2}'|tr -d '",\r')
echo -e "Adding roles"
app4_roles=(seller customer orgAdmin admin data-provider data-consumer)
for (( i=0; i<${#app4_roles[@]}; i++ )) do
  curl -s \
        --request POST \
        --header "Content-Type: application/json" \
        --header "X-Auth-token: ${idm_token}" \
        --data-binary "{
          \"role\": {
            \"name\": \"${app4_roles[$i]}\"
          }
        }" \
  "https://accounts.${DOMAIN}/v1/applications/${app4_id}/roles"
done
echo -e "\n\nReplacing BAE_ID and BAE_SECRET in the repo files"
grep -rl 'BAE_ID' * --exclude-dir scripts | xargs sed -i "s|BAE_ID|${app4_id}|g"
grep -rl 'BAE_SECRET' * --exclude-dir scripts | xargs sed -i "s|BAE_SECRET|${app4_secret}|g"

echo -e "Replacing BAE_PAYPAL_ID and BAE_PAYPAL_SECRET in the repo files"
grep -rl 'BAE_PAYPAL_ID' * --exclude-dir scripts | xargs sed -i "s|BAE_PAYPAL_ID|${BAE_PAYPAL_ID}|g"
grep -rl 'BAE_PAYPAL_SECRET' * --exclude-dir scripts | xargs sed -i "s|BAE_PAYPAL_SECRET|${BAE_PAYPAL_SECRET}|g"

echo -e "Replacing IDM_USERID, IDM_EMAIL and IDM_PWD in the repo files"
grep -rl 'IDM_USERID' * --exclude-dir scripts | xargs sed -i "s|IDM_USERID|${IDM_USERID}|g"
email_files=$(grep -rl 'IDM_EMAIL' * --exclude-dir scripts)
for i in $email_files
do
        sed -i "s|IDM_EMAIL|${IDM_EMAIL}|g" $i
done
grep -rl 'IDM_PWD' * --exclude-dir scripts | xargs sed -i "s|IDM_PWD|${IDM_PWD}|g"
echo -e "$(tput bold)$(tput setaf 5)Successfully added applications to IDM$(tput sgr 0)"

#deployment of services to Docker Swarm (part 2)
sleep 5
echo -e "$(tput bold)$(tput setaf 3)\n\nDeploying remaining services to Docker Swarm....$(tput sgr 0)"
sudo docker stack deploy -c services/tenant-manager.yml ${STACK}
sudo docker stack deploy -c services/bae.yml ${STACK}
echo -e "$(tput bold)$(tput setaf 5)Successfully deployed services to Docker Swarm$(tput sgr 0)"
echo -e "\n"
