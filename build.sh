# Set the working directory to /var/www
cd /var/www

# Check if the "artisan" file does not exist in the specified directory
if [ ! -f "/var/www/pterodactyl/artisan" ]; then
    echo "We tried to find your Artisan file but we couldn't. Please move to the directory where you installed the Panel and re-run this script. Have a Good Day!"
else
    echo "Your Artisan File has been found!"
    sleep 2

    echo "Checking if unzip is installed"
    # Attempt to install unzip using apt (for Ubuntu systems)
    apt update -y 2> /dev/null
    apt install unzip -y 2> /dev/null

    echo "Backing up previous panel files in case something goes wrong!"
    # Create a backup of the current "public" and "resources" directories
    zip -r /var/www/PterodactylBackup-$(date +"%Y-%m-%d").zip /var/www/pterodactyl /var/www/pterodactyl/resources 2> /dev/null

    echo "Downloading the Theme you picked"
    # Create a temporary directory for downloading the zip file
    mkdir -p /var/www/tempdown && cd /var/www/tempdown
    # Download the zip file from the specified URL
    wget https://github.com/YUDAMODS/THEME-PANEL/raw/master/pterodactyl.zip -O pterodactyl.zip
    # Unzip the downloaded file
    unzip pterodactyl.zip

    echo "Copying the extracted files to the /var/www/pterodactyl directory"
    # Copy the extracted files to the necessary location
    cp -r * /var/www/pterodactyl/

    echo "Files have been copied over!"
    sleep 2

    echo "Removing the temp folders created in the copy process"
    # Remove the temporary download directory
    cd /var/www
    rm -rf /var/www/tempdown

    echo "Theme installation complete! Have a good day and don't forget to refresh your browser cache! (CTRL + F5)"
    echo "-Will"
fi
