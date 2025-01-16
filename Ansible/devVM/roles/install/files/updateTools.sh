#!/bin/bash

usage () {
  cat <<EOM
Usage: 
  $(basename $0) [options] [provider|product|filepath] [version | number]

Summary:


Considerations:
  * Supported products: terraform and packer. 
    Might add more in the future.
  * It installs supported products to /usr/local/bin/
  * Terraform providers are installed in ~/.terraform.d/plugin-cache/linux_amd64/ and 
    it assumes these directories have been created already.
  * -i and -ls only support these terraform providers: aws, azurerm, google, local, null, random and template.
    I might work on making it more generic, but you can add more providers to hashProvs array. This is just I do not make a call over the network just to check if a provider exists or not.

Options:
  -ls         Lists Providers/Products available in https://releases.hashicorp.com/. 
              By default it lists the last 3 versions.
              If you pass a number(n) at the end, 
              it will list the last n versions.

  -v          Lists the installed Providers/Products in the local system. 
              Valid products are: terraform and packer.

  -i          Installs the provided Provider/Products version.

  -f          It installs/updates Terraform providers from file. 
              Each line should have a link to the terraform provider.
              Sample:
              https://releases.hashicorp.com/terraform-provider-azurerm/2.2.0/terraform-provider-azurerm_2.2.0_linux_amd64.zip

  -h, --help  Displays this message.

Examples
-ls
  main.sh -ls terraform 5   Lists the last 5 terraform versions.
  main.sh -ls packer        Lists the last 3 (default) packer versions.
  main.sh -ls azurerm 6     Lists the last 6 azurerm terraform provider versions.
  main.sh -ls template      Lists the last 3 (default) terraform template versions.

-v
  main.sh -v terraform      Shows the current terraform installed version.
  main.sh -v azurerm        Lists all the azurerm terraform provider versions installed.

-i
  main.sh -i terraform 0.12.24  Installs teraform version 0.12.24
  main.sh -i azurerm 2.2.0      Installs azurerm terraform provider version 2.2.0

-f
  main.sh -f providers.txt  Installs/Updates all the providers listed in providers.txt

Implementation:
  version         0.0.1
  author          Marcelo Zambrana Villarroel
  license         GNU General Public License
EOM
}

list() {
  product=${1,,}
  numVersions=${2,,}
  type=${3,,}

  if [ -z "$numVersions" ] || [ "$numVersions" == "0" ]
  then
    numVersions=3
  fi

  baseURL="https://api.releases.hashicorp.com/v1"
#  if [ "$type" == "provider" ];
#  then
    # echo "list providers"
#    url="https://releases.hashicorp.com/terraform-provider-"$product
#  elif [ "$type" == "product" ];
#  then
    # echo "list products"
#    url="https://releases.hashicorp.com/"$product
#  else
#    echo "not supported yet"
#  fi*/

  # if wget is not an option, we could use lynx if it installed.
  # lynx -dump -nolist https://releases.hashicorp.com/terraform-provider-azurerm/ | grep -A 3  ../
  # wget -qO- $url | sed -e 's/<[^>]*>//g;s/^ //g' -e '/^\s*$/d' | grep -A $numVersions  ../ | tail -n $numVersions
  result=$(curl -sS  $baseURL/releases/$product?limit=$numVersions | jq -r .[].version)
  if [ -z "$result" ]
  then
    echo "No hashicorp product named $product found. Looking for providers instead..."
    result=$(curl -sS  $baseURL/releases/terraform-provider-$product?limit=$numVersions | jq -r .[].version)
    if [ -z "$result" ]
    then
       echo "No terraform provider named $product found either."
       read -p "Would you like to see a list of all the products and providers available in https://releases.hashicorp.com/ [ y/n ]?:" yn
        case $yn in
          [Yy]* ) 
            curl -sS  $baseURL/products | jq -r .[] 
          ;;
          [Nn]* ) echo "Good Bye.";;
          * ) ;;
        esac
    else
      echo "Listing last $numVersions terraform-provider-$product $type versions:"
      echo "$result"
    fi
  else
    echo "Listing last $numVersions $product $type versions:"
    echo "$result"
  fi
}

install() {
  product=${1,,}
  reqVer=${2,,}
  type=${3,,}

  echo "Installing $type $product $reqVer"

  if [ "$type" == "product" ]
  then
    echo "Getting current $product version."
    case $product in
      terraform)
        curVer=$(terraform -version -json | jq -r .terraform_version)
      ;;
      packer)
        rawVer=`packer -v`
        curVer=$rawVer 
      ;;
      *)
        echo "$1 not supported yet."
      ;;
    esac

    echo "Current $curVer, requested version $reqVer"
    if [ "$curVer" == "$reqVer" ]
    then
      echo "You already have $product $reqVer version installed."
    else
      echo "Checking if $product $reqVer is available..."
      wget_output=$(sudo wget -q https://releases.hashicorp.com/$product/"$reqVer"/"$product"_"$reqVer"_linux_amd64.zip -O /usr/local/bin/"$product"_"$reqVer"_linux_amd64.zip)

      if [ $? -ne 0 ]; then
        echo "$product version $reqVer Not found. Please check https://releases.hashicorp.com/$product for valid versions."
        sudo rm /usr/local/bin/"$product"_"$reqVer"_linux_amd64.zip
      else
        echo "$product $reqVer Downloaded."

        # backing up current version
        echo "Backing up current version $curVer."
        sudo mv /usr/local/bin/$product "/usr/local/bin/${product}_${curVer}_old"

        # install requested version
        echo "Installing $product $reqVer."
        sudo unzip "/usr/local/bin/${product}_${reqVer}_linux_amd64.zip" -d /usr/local/bin/
        sudo chown $USER:$USER /usr/local/bin/$product
        sudo rm  "/usr/local/bin/${product}_${reqVer}_linux_amd64.zip"

        echo "$product updated from version $curVer to $reqVer."
      fi
    fi
  elif [ "$type" == "provider" ];
  then
    # pathProvider=("~/.terraform.d/plugin-cache/linux_amd64/terraform-provider-"$product"_v"$reqVer)
    # pathProvider=(/home/marcelo/.terraform.d/plugin-cache/linux_amd64/terraform-provider-azurerm_v2.3.0*)
    providerFile=$(ls ${providerPathFolder}terraform-provider-"$product"_v"$reqVer"* 2> /dev/null | wc -l)
    # if [ -e "$pathProvider[0]" ]
    if [ "$providerFile" != "0" ]
    then
      echo "You already have $product $reqVer version installed in  $providerPathFolder"
    else
    echo "Install provider $product version $reqVer in $providerPathFolder"
      
      wget_output=$(wget -q https://releases.hashicorp.com/terraform-provider-"$product"/"$reqVer"/terraform-provider-"$product"_"$reqVer"_linux_amd64.zip)

      if [ $? -ne 0 ]
      then
        echo "Download failed. Provider $product version $reqVer Not found. Please check https://releases.hashicorp.com/terraform for valid versions."
      else
        unzip '*.zip'
        rm terraform*.zip
        mv terraform-provider-* $providerPathFolder
      fi
    fi
  else
    echo "not supported yet"
  fi
}

installFromFile() {
  pathFile=${1,,}
  echo "Update/Install Terraform providers from file: $pathFile"
  if [ -f "$pathFile" ]
  then
    wget -q -i $pathFile
    unzip '*.zip'
    rm terraform*.zip
    mv terraform-provider-* $providerPathFolder
    echo "Update/Installation completed."
  else
    echo "$pathFile not found or wrong content/not valid links on them."
  fi
}

version() {
  product=${1,,}
  type=${2,,}
  echo "Current $product installed versions:"
  if [ "$type" == "provider" ];
  then
    # echo "list provider versions"
    ls -A -1 $providerPathFolder | grep $product
  elif [ "$type" == "product" ];
  then
    # echo "list product versions"
    $product -v
  else
    echo "not supported yet"
  fi
}

hashProds=(packer terraform)
hashProvs=(aws azurerm google local null random template)

providerPathFolder=~/.terraform.d/plugin-cache/linux_amd64/

# echo "You provided the arguments: $@"
# echo "You provided $# arguments"
if [ "$#" == "0" ]
then
    echo "Wrong syntax."
    usage
else
  type=""
  # echo "second parameter $2"
  case $1 in
    -ls)
        if [ -z "$2" ]
          then
            usage
          else
            list "$2" "$3" "$type"
        fi
      # if [[ " ${hashProds[@]} " =~ " $2 " ]]; then
      #   # echo "list products"
      #   type="product"
      #   list "$2" "$3" "$type"
      # elif [[ " ${hashProvs[@]} " =~ " $2 " ]]; then
      #   # echo "list providers"
      #   type="provider"
      #   list "$2" "$3" "$type"
      # else
      #   echo "Wrong syntax."
      #   usage
      # fi
    ;;
    -i)
      if [ -z "$3" ]
      then
        echo "Install failed. Wrong syntax."
        usage
      else
        if [[ " ${hashProds[@]} " =~ " $2 " ]]; then
          # echo "install products"
          type="product"
          install "$2" "$3" "$type"
        elif [[ " ${hashProvs[@]} " =~ " $2 " ]]; then
          # echo "install providers"
          type="provider"
          install "$2" "$3" "$type"
        else
          echo "Install failed. Product/provider $2 not found or maybe not supported yet."
          usage
        fi
      fi
    ;;
    -f)
      if [ -z "$2" ]
      then
        echo "Install from file failed. You need to pass the path to the file."
        usage
      else
        installFromFile "$2"
      fi
    ;;
    -v)
      if [[ " ${hashProds[@]} " =~ " $2 " ]]; then
        # echo "list product versions"
        type="product"
        version "$2" "$type"
      elif [[ " ${hashProvs[@]} " =~ " $2 " ]]; then
        # echo "list provider versions"
        type="provider"
        version "$2" "$type"
      else
        echo "List versions failed. Product/provider $2 not found or maybe not supported yet."
        usage
      fi
    ;;
    -h|--help)
      usage
      ;;
    *)
      echo "$1 not a valid option."
      usage
    ;;
  esac
fi
