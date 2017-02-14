#!/bin/bash
#www user is always created. It's the user used by httpd!
user=www
pwd=$PASSWORD
# Creating the www user only if it does not exist
ret=false
getent passwd $user >/dev/null 2>&1 && ret=true

if $ret; then
echo "user already exists";
else

useradd $user -d /data/$user
# Comments supose $user is www
# Setting password for the www user
echo "${user}:${pwd}" | chpasswd
# Add 'www' user to sudoers
echo "${user}  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/$user
echo "user created"
fi
mkdir -p /data/$user/html
chown -R $user:$user /data/$user
chmod -R 777 /data/$user

#Creating another user if $USER is not www
user=$USER
ret=false
getent passwd $user >/dev/null 2>&1 && ret=true

if $ret; then
echo "user already exists";
else

useradd $user -d /home/$user
# Setting password for the !www user
echo "${user}:${pwd}" | chpasswd
# Add !'www' user to sudoers
echo "${user}  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/$user
echo "user created"
fi
mkdir -p /home/$user
cp /etc/skel/.b* /home/$user
chown -R $user:$user /home/$user

