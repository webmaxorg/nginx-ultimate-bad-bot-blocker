#!/bin/bash
# Curl Testing Script for Nginx Ultimate Bad Bot Blocker
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker

##############################################################################                                                                
#       _  __     _                                                          #
#      / |/ /__ _(_)__ __ __                                                 #
#     /    / _ `/ / _ \\ \ /                                                 #
#    /_/|_/\_, /_/_//_/_\_\                                                  #
#       __/___/      __   ___       __     ___  __         __                #
#      / _ )___ ____/ /  / _ )___  / /_   / _ )/ /__  ____/ /_____ ____      #
#     / _  / _ `/ _  /  / _  / _ \/ __/  / _  / / _ \/ __/  '_/ -_) __/      #
#    /____/\_,_/\_,_/  /____/\___/\__/  /____/_/\___/\__/_/\_\\__/_/         #
#                                                                            #
##############################################################################                                                                

# ************************
# Set Terminal Font Colors
# ************************

bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
defaultcolor=$(tput setaf default)
thisip=$(curl -s ifconfig.co)

# Print IP info of system
ip addr

echo "${bold}${green}--------------------------"
echo "${bold}${green}Whitelist IP Test Starting"
echo "${bold}${green}--------------------------"
printf "\n\n"

echo "${bold}${green}-------------------------"
echo "${bold}${green}Blacklisting own IP First"
echo "${bold}${green}-------------------------"
printf "\n\n"

sudo truncate -s 0 ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/blacklist-ips.conf
printf '%s\t%s\n' "${thisip}" "1;" >> ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/blacklist-ips.conf
printf '%s\t%s\n' "127.0.0.1" "1;" >> ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/blacklist-ips.conf
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/blacklist-ips.conf /etc/nginx/bots.d/blacklist-ips.conf

echo "${bold}${green}--------------------"
echo "${bold}${green}Now Whitelist own IP"
echo "${bold}${green}--------------------"
printf "\n\n"

sudo truncate -s 0 ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/whitelist-ips.conf
printf '%s\t%s\n' "${thisip}" "0;" >> ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/whitelist-ips.conf
printf '%s\t%s\n' "127.0.0.1" "0;" >> ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/whitelist-ips.conf
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/whitelist-ips.conf /etc/nginx/bots.d/whitelist-ips.conf

echo "${bold}${green}---------------"
echo "${bold}${green}Reloading Nginx"
echo "${bold}${green}---------------"
printf "\n\n"
sudo nginx -t && sudo nginx -s reload


echo "${bold}${yellow}-----------------------------------------------------------------------"
echo "${bold}${yellow}Sleeping for 10 seconds to allow Nginx to Properly Reload inside Travis"
echo "${bold}${yellow}-----------------------------------------------------------------------"
printf "\n\n"
sleep 10s

# *************************************************
# Function Curl Test 1 - Test User Domain Whitelist
# *************************************************

#run_curltest1 () {
#if curl http://localhost:9000 -e http://www.myowndomain.com 2>&1 | grep -i 'Welcome'; then
#   echo "${bold}${green}PASSED - User whitelist-domains.conf working"
#else
#   echo "${bold}${red}FAILED - User whitelist-domains.conf NOT working"
#   #exit 1
#fi
#}
#run_curltest1

# *************************************************
# Function Curl Test 2 - Test User Domain Whitelist
# *************************************************

#run_curltest2 () {
#if curl http://localhost:9000 -e http://www.myotherdomain.com 2>&1 | grep -i 'Welcome'; then
#   echo "${bold}${green}PASSED - User whitelist-domains.conf working"
#else
#   echo "${bold}${red}FAILED - User whitelist-domains.conf NOT working"
#   #exit 1
#fi
#}
#run_curltest2


echo "${bold}${green}-----------------------------"
echo "${bold}${green}Whitelisting IP Test Complete"
echo "${bold}${green}-----------------------------"
printf "\n\n"

# *************************************************************
# Copy all .conf files used in Testing to a folder for checking
# *************************************************************

printf "\n"
echo "${bold}${green}------------------------------------------------------------"
echo "${bold}${green}Make Backup all conf files and folders used during this test"
echo "${bold}${green}------------------------------------------------------------"
printf "\n"
sudo cp /etc/nginx/bots.d/* ${TRAVIS_BUILD_DIR}/.dev-tools/_conf_files_testing_changes_ip_whitelist/bots.d/
sudo cp /etc/nginx/conf.d/* ${TRAVIS_BUILD_DIR}/.dev-tools/_conf_files_testing_changes_ip_whitelist/conf.d/
sudo cp /etc/nginx/sites-available/default.vhost ${TRAVIS_BUILD_DIR}/.dev-tools/_conf_files_testing_changes_ip_whitelist/default.vhost
sudo cp /etc/nginx/nginx.conf ${TRAVIS_BUILD_DIR}/.dev-tools/_conf_files_testing_changes_ip_whitelist/nginx.conf


# **********************
# Exit With Error Number
# **********************

exit ${?}

