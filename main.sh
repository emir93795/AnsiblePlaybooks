#!/bin/bash

#Available colors (Seen in stackoverflow.com)
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    
menu(){
    echo -e "${MENU}*******************************************************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Install and configure ansible directly in my computer      **${NORMAL}"
    echo -e "${MENU}*                                                                 *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Create an amazon EC2 instance directly (I already have Ansible) **${NORMAL}"
    echo -e "${MENU}**${NUMBER}${MENU} (Remember that you must have an Amazon Key!)                 **${NORMAL}"
    echo -e "${MENU}*                                                                 *${NORMAL}"
    echo -e "${MENU}*******************************************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter OR ${RED_TEXT} press enter to exit. ${NORMAL}"
    read opt
}

#Function to set amazon keys environment values
function environmentValues(){
    echo -e "${MENU}Please, specify the amazon access key id:${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        export AWS_ACCESS_KEY=$zone
    fi
    echo -e "${MENU}Please, specify the amazon secret key:${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        export AWS_SECRET_KEY=$zone
    fi
}

function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

#Function that installs ansible
function ansibleInstallation(){
    if yum list installed ansible >/dev/null 2>&1; then
        echo -e "${NUMBER}Ansible is already installed.\n${NORMAL}"
    else
        sudo rpm -ivh --force http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        sudo yum install -y ansible
        #Check if ansible is correctly installed
        if yum list installed ansible >/dev/null 2>&1; then
            echo -e "${NUMBER}Ansible was correctly installed.\n${NORMAL}"
        else   
            echo -e "${RED_TEXT}Ansible was not correctly installed.\n${NORMAL}"
        fi
    fi
    advise
}
#Function that advises of the ssh-agent
function advise(){
    echo -e "${RED_TEXT}Please remember that you need to have your SSH keys configured, \nbefore you proceed with the process.\n${NORMAL}"
    echo -e "${MENU}You can configure your keys using:${NORMAL}"
    echo -e "${NUMBER}    ssh-agent bash${NORMAL}"
    echo -e "${NUMBER}    ssh-add pathTOyourKey/keyName.pem\n${NORMAL}"
    echo -e "${RED_TEXT}(The key must have special permissions (400 or 600), use chmod for that.${NORMAL}"
}
    
#Function that fills create_ec2_Instance.yml file
function instanceParameters(){
    echo -e "${NUMBER}Press [ENTER] to leave default values.${NORMAL}"
    echo -e "${NUMBER}Please, specify the zone where the instance will be created: (Ex.: sa-east-1a)${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        sed -i "s/sa-east-1a/$zone/g" create_ec2_Instance.yml
    fi
    echo -e "${NUMBER}Specify an specific AMI id [Default is Amazon Linux ami || ami-8737829a]:${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        sed -i "s/ami-8737829a/$zone/g" create_ec2_Instance.yml
    fi 
    echo -e "${NUMBER}Define the instance_type you want [Default is t2.micro]:${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        sed -i "s/t2.micro/$zone/g" create_ec2_Instance.yml
    fi 
    echo -e "${NUMBER}Define the region (Ex.: sa-east-1):${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        sed -i "s/sa-east-1/$zone/g" create_ec2_Instance.yml
    fi 
    echo -e "${NUMBER}Define the key name that will be used to connect to instance:${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        sed -i "s/AmazonKeyValue/$zone/g" create_ec2_Instance.yml
    fi 
    echo -e "${NUMBER}Define the subnet id: (Ex.: subnet-03833a66)${NORMAL}"
    read zone
    if [ "$zone" != "" ]; then
        sed -i "s/vpc-e4921349/$zone/g" create_ec2_Instance.yml
    fi
    echo -e "${NUMBER}Instance tag will be 'Moodle'. ${NORMAL}"
}

#Funtion that installs moodle using ansible
#Beginning menu
clear
menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        option_picked "Installing ansible...";
        ansibleInstallation
        ;;

        2) clear;
        option_picked "Option 2 Picked";
        if yum list installed ansible >/dev/null 2>&1; then
            advise
            environmentValues
            instanceParameters
        else
            echo -e "${RED_TEXT}Ansible is not installed. Please choose the first option instead.\n${NORMAL}"
        fi
        ;;

        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        menu;
        ;;
    esac
fi
done
