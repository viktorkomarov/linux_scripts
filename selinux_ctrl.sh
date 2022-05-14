#!/bin/bash

description=$(cat <<EOF
        Script for controlling SELinux. You should have ROOT privilege. 
        You can show/set SELinux status and activation in configuration files in intercativing mode.
        Argument --help for reading this message.
EOF
)

help_msg () {
    echo "$description"
    exit $1;
}


if [ "$1" = "--help" ]; then
    help_msg 0
fi

# root check
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
    help_msg 1
fi


echo "Show SELinux status ? [yes/no]:\n"
read read_en
if [[ read_en = "yes" ]]; then 
    echo "$(selinuxenabled)"
fi

echo "Show SELinux configuration mode ? [yes/no]:\n"
read read_en
if [[ read_en = "yes" ]]; then 
    echo "$(sed -n 's/^SELINUX=//p' /etc/selinux/config)"
fi


echo "Enable SELinux status  ? [yes/no]:\n"
read read_en
if [[ read_en = "yes" ]]; then 
    setenforce 1
else 
    setenforce 0
fi

echo "Enable SELinux configuration mode ? [yes/no]:\n"
read read_en
if [[ read_en = "yes" ]]; then 
    sed -i 's/^SELINUX=[A_Za-z]*$/SELINUX=enforcing/' /etc/selinux/config
else 
    sed -i 's/^SELINUX=[A_Za-z]*$/SELINUX=disabled/' /etc/selinux/config
fi


exit 0


