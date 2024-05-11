#!bin/bash

function error() {
            echo "Something went wrong with $system."
            echo "Please try again!"
            exit 1

}

echo -e 'Hello would you like to start Jellyfin and Caddy setup, or disable it? (1-2) \n' 
echo '1.    Enable'
echo '2.    Disable'

read choice

case $choice in 

    1) #User decieds to start Jellyfin and Caddy
        sudo systemctl start jellyfin && sleep 3 #starting jellyfin
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
            exit 1
        else
            system="caddy"
            error
        fi
        ;;

    2) #User decides to stop Jellyfin and Caddy
        sudo systemctl stop jellyfin && sleep 3
        systemctl stop caddy 
            
        if [[ `systemctl status jellyfin | grep "inactive (dead)"` ]]; then #checking to see if jellyfin is down
            echo "Jellyfin is now turned off."
        else
            echo "Something went wrong please try again"
            exit 1
        fi  

        if [[ `systemctl status jellyfin | grep "inactive (dead)"` ]]; then  #checking to see if caddy is down
            echo "Caddy is now turned off."
            exit 1
        else
            echo "Something went wrong please try agian"
            exit 1
        fi
        ;;
esac
