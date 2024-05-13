#!bin/bash

function error() {
            echo "Something went wrong with $system."
            echo "Please try again!"
            exit 1

}
function check() { #check to see if system is already down or up so user doesn't create mutiple instances, as this can lead to confusion on for caddy
    if [[ `systemctl status $system | grep $status` ]]; then
        echo "system is already running"
        exit 0

}

echo -e 'Hello would you like to start Jellyfin and Caddy setup, or disable it? (1-2) \n' 
echo '1.    Enable'
echo '2.    Disable'

read choice

case $choice in 

    1) #User decieds to start Jellyfin and Caddy
        
        status="active" #setting status to active so check can run

        #jellyfin
        system="jellyfin" #setting system varible to jellyfin so check can run 
        check
        sudo systemctl start jellyfin && sleep 3 #starting jellyfin
        
        #caddy
        system="caddy"
        check
        systemctl start caddy #stating caddy
        sleep 2

        if [[ `systemctl status jellyfin | grep "active"` ]]; then #Checking to make sure Jellyfin is up
            echo "Jellyfin is up and runing"
        else
            system="jellyfin"
            error
        fi
        sleep 5
        if [[ `systemctl status caddy | grep "active"` ]]; then #Checking to make sure caddy is up
            echo -e 'Caddy is up and runing. \n'
            exit 0
        else
            system="caddy"
            error
        fi
        ;;

    2) #User decides to stop Jellyfin and Caddy
        status="inactive (dead)"

        #jellyfin
        system="jellyfin" #setting system varible to jellyfin so check can run
        check  #running check to see if system is already down.
        sudo systemctl stop jellyfin && sleep 3
        
        #caddy
        system="caddy" #setting system varible to caddy so check can run 
        check  #running check to see if system is already down.
        systemctl stop caddy 
            
        if [[ `systemctl status jellyfin | grep "inactive (dead)"` ]]; then #checking to see if jellyfin is down
            echo "Jellyfin is now turned off."
        else
            echo "Something went wrong please try again"
            exit 1
        fi  

        if [[ `systemctl status jellyfin | grep "inactive (dead)"` ]]; then  #checking to see if caddy is down
            echo "Caddy is now turned off."
            exit 0
        else
            echo "Something went wrong please try agian"
            exit 1
        fi
        ;;
esac
