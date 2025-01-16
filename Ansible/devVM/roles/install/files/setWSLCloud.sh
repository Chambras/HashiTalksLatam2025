#!/bin/bash

OPTIND=1
subscriptionID=""
subscriptionName=""
subShortName=""
tenantID=""
tenantName=""
clientID=""
clientName=""
clientSecret=""
clientCertificatePath=""
clientCertificatePEMPath=""
clientCertificatePassword=""
cloudType=""

# setting the script and config path
SCRIPTDIR=$HOME"/.local/bin"

# getting defaults
defaults=`jq -r '.profiles.defaults' $SCRIPTDIR/config.json`
defSubID=`jq -r '.profiles.defaults.subscriptionID' $SCRIPTDIR/config.json`
defSubName=`jq -r '.profiles.defaults.subscriptionName' $SCRIPTDIR/config.json`
defSubShortName=`jq -r '.profiles.defaults.subShortName' $SCRIPTDIR/config.json`
deftenantID=`jq -r '.profiles.defaults.tenantID' $SCRIPTDIR/config.json`
deftenantName=`jq -r '.profiles.defaults.tenantName' $SCRIPTDIR/config.json`
defclientID=`jq -r '.profiles.defaults.clientID' $SCRIPTDIR/config.json`
defclientName=`jq -r '.profiles.defaults.clientName' $SCRIPTDIR/config.json`
defclientSecret=`jq -r '.profiles.defaults.clientSecret' $SCRIPTDIR/config.json`
defclientCertificatePath=`jq -r '.profiles.defaults.clientCertificatePath' $SCRIPTDIR/config.json`
defclientCertificatePEMPath=`jq -r '.profiles.defaults.clientCertificatePEMPath' $SCRIPTDIR/config.json`
defclientCertificatePassword=`jq -r '.profiles.defaults.clientCertificatePassword' $SCRIPTDIR/config.json`
defcloudType=`jq -r '.profiles.defaults.cloudType' $SCRIPTDIR/config.json`

cloudNames=('AzureCloud' 'AzureChinaCloud' 'AzureUSGovernment' 'AzureGermanCloud')
cloudTypes=('public' 'china' 'usgovernment' 'german')

listSubs() {
    echo "Listing all subscriptions"
    jq -r '.profiles.tenants[].subscriptions[] | .subscriptionName + ": " + .subscriptionID + " --- " + .subShortName' $SCRIPTDIR/config.json
}

setSubscription() {
    echo 'Settig Azure Environment...'
    echo "Looking for subscription: ${s}"
    echo "Getting SubscriptionID"
    ## using long name
    # subscriptionID=`jq -r --arg s "$s" '.profiles.tenants[].subscriptions[] | select (.subscriptionName==$s) | .subscriptionID' $SCRIPTDIR/config.json`
    ## using short name
    subscriptionID=`jq -r --arg s "$s" '.profiles.tenants[].subscriptions[] | select (.subShortName==$s) | .subscriptionID' $SCRIPTDIR/config.json`
    echo "*** SubscriptionID: ${subscriptionID}"
    subscriptionName=$s

    if [ -z "${subscriptionID}" ]; then
        echo "Subscription name was not provided, using defaul one."
        subscriptionID=$defSubID
        subscriptionName=$defSubName
    fi

    echo "Gettig tenantID for subscription: ${subscriptionName}"
    tenantID=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .tenantID' $SCRIPTDIR/config.json`
    echo "TenantID: ${tenantID}"

    echo "Gettig tenantName for subscription: ${subscriptionName}"
    tenantName=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .tenantName' $SCRIPTDIR/config.json`
    echo "GenantName: ${tenantName}"

    echo "Getting cloud type. If not found, it will use ${defcloudType}"
    cloudType=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .cloudType' $SCRIPTDIR/config.json`
    ( [ -z "$cloudType" ] || [ "$cloudType" = "null" ] ) && cloudType=${defcloudType}
    echo "CloudType: ${cloudType}"

    case $cloudType in
        public)
            cloudName="AzureCloud"
        ;;
        government)
            cloudName="AzureUSGovernment"
        ;;
        china)
            cloudName="AzureChinaCloud"
        ;;
        german)
            cloudName="AzureGermanCloud"
        ;;
    esac

    echo "Getting clientID"
    clientID=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .servicePrincipals[0].clientID' $SCRIPTDIR/config.json`
    [ -z "$clientID" ] && clientID=$defclientID
    echo "*** ClientID: ${clientID}"

    echo "Getting clientName"
    clientName=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .servicePrincipals[0].clientName' $SCRIPTDIR/config.json`

    ## Long if version
    #if [ -z "$clientName" ] || [ "$clientName" = "null" ] ; then
    #    echo "clientName was not provided, using defaul one: $defclientName"
    #    clientName=$defclientName
    #fi

    ( [ -z "$clientName" ] || [ "$clientName" = "null" ]) && clientName=$defclientName || echo "clientName: ${clientName}"
    echo "*** ClientName: ${clientName}"

    echo "Getting clientCertificatePEMPath"
    clientCertificatePEMPath=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .servicePrincipals[0].clientCertificatePEMPath' $SCRIPTDIR/config.json`
    ( [ -z "$clientCertificatePEMPath" ] || [ "$clientCertificatePEMPath" = "null" ]) && clientCertificatePEMPath=$defclientCertificatePEMPath
    # echo "clientCertificatePEMPath: ${clientCertificatePEMPath}"

    echo "Getting clientCertificatePath"
    clientCertificatePath=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .servicePrincipals[0].clientCertificatePath' $SCRIPTDIR/config.json`
    ( [ -z "$clientCertificatePath" ] || [ "$clientCertificatePath" = "null" ]) && clientCertificatePath=$defclientCertificatePath
    # echo "clientCertificatePath: ${clientCertificatePath}"

    echo "Getting clientCertificatePassword"
    clientCertificatePassword=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .servicePrincipals[0].clientCertificatePassword' $SCRIPTDIR/config.json`
    ( [ -z "$clientCertificatePassword" ] || [ "$clientCertificatePassword" = "null" ]) && clientCertificatePassword=$defclientCertificatePassword
    # echo "clientCertificatePassword: ${clientCertificatePassword}"

    echo "Getting clientSecret"
    clientSecret=`jq -r --arg s "$subscriptionID" '.profiles.tenants[] | select (.subscriptions[].subscriptionID==$s) | .servicePrincipals[0].clientSecret' $SCRIPTDIR/config.json`
    ( [ -z "$clientSecret" ] || [ "$clientSecret" = "null" ]) && clientSecret=$defclientSecret
    # echo "clientSecret: ${clientSecret}"

    echo "Setting Azure cloud to: ${cloudName}"
    az cloud set -n ${cloudName}
    echo "Authenticating using client: ${clientName} and certificate: ${clientCertificatePEMPath} into tenant: ${tenantName}"
    az login --service-principal -u ${clientID} -p ${clientCertificatePEMPath} -t ${tenantID} -o table
    #az login --service-principal -u ${clientName} -p ${clientCertificatePEMPath} -t ${tenantID} -o table
    echo "Setting subscription ${subscriptionName} as default"
    az account set -s ${subscriptionID}

    echo "Setting environment variables for Terraform and other tools."
    export ARM_TENANT_NAME=$tenantName
    export ARM_TENANT_ID=$tenantID

    export ARM_SUBSCRIPTION_ID=$subscriptionID
    # Setting the value to the Name works if you use provider 1.36.1 or older.
    #export ARM_CLIENT_ID="http://prsnlmarcelocli"
    # Starting with provider version 1.37.0 it only works if you set the value to the ID instead of the name.
    export ARM_CLIENT_ID=$clientID
    # setting certificate path, for some reason terraform needs full path
    # will try to find how to pass relative one instead (~/.azure )
    export ARM_CLIENT_CERTIFICATE_PATH=$clientCertificatePath
    export ARM_CLIENT_CERTIFICATE_PEM_PATH=$clientCertificatePEMPath
    # if using selfsigned certificate from az ad sp create-for-rbac --create-cert, leave password empty otherwise you need to put the password.
    export ARM_CLIENT_CERTIFICATE_PASSWORD=$clientCertificatePassword
    # client secret since some applications do not support certificate
    export ARM_CLIENT_SECRET=$clientSecret

    # Not needed for public, required for usgovernment, german, china
    export ARM_ENVIRONMENT=$cloudType

    # Setting Dev Environment
    export DEV_ENVIRONMENT=$subscriptionName

    # Setting terraform token
    export TF_API_TOKEN=`grep 'token' ~/.terraformrc | awk '{print $3}' | tr -d \''"'`

    echo "Environment set for ${cloudName}. You can now use az cli or Terraform against Azure subscription ${subscriptionName}."
    az account list -o table
}



#if [ -z "${s}" ] || [ -z "${t}" ]; then
#    usage
#fi

#echo "s = ${subscriptionID}"
#echo "p = ${t}"

#echo "default SubscriptionID: ${defaults}" 

usage() { echo "Usage: $0 [-s <SubscriptionID>] [-l ]" 1>&2; exit 1; }
# echo "printing parameters for testing."
# echo "$@"

# for now only supports passing the subscription name.
## TODO: add support to list all subscriptions
# while getopts ":s:l" opt; do
while getopts ":s:l" opt; do
    case "${opt}" in
        s)
            s=${OPTARG}
            setSubscription $s
            ;;
        # t)
        #     t=${OPTARG}
        #     echo "tenant option. ${t}"
        #     ;;
        ## TODO: add support to list all subscriptions
        l)
            # ls=${OPTARG}
            listSubs
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

