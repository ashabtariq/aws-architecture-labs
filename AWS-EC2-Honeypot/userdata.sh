#!/bin/bash
sudo apt-get update

#Step 1: Install system dependencies
sudo apt-get install git python3-pip python3-venv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind

#Step 2: Create a user account
sudo adduser --disabled-password cowrie
sudo su - cowrie

#Step 3: Checkout the code
git clone http://github.com/cowrie/cowrie
cd cowrie

#Step 4: Setup Virtual Environment
pwd
python3 -m venv cowrie-env

#Step 5: Install configuration file (Optional)


#Step 6: Starting Cowrie
bin/cowrie start

#use setcap to give permissions to Python to listen on ports<1024
setcap cap_net_bind_service=+ep /usr/bin/python3