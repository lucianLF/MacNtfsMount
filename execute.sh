# !/bin/bash

# Enter hard disk name
input_name(){
    read -p "Please enter（请输入）:" name
    if  [[ ${disk_array[${name}]} == '' ]] && [[ $name!='' ]];
    then
        echo "\033[31m输入错误请重新输入\033[0m"
        input_name
    fi
}
# Set up and mount the hard disk
mount_drive(){
    if [ -f "/etc/fstab" ];then   
        cp /etc/fstab /tmp/fstab
    else
        touch /tmp/fstab
    fi
    echo LABEL=${key} none ntfs rw,auto,nobrowse >> /tmp/fstab
    cp /tmp/fstab /etc/fstab 
    rm -f /tmp/fstab
    cd /Users
    for file in $(ls)
    do
        if [ -d /Users/$file/ ] ;then
            cd /Users/$file/
            if [ -d "./Desktop" ];then
                rm -f /Users/$file/Desktop/${key}
                echo '\033[32mLink at:'/Users/$file/Desktop/${key}'\033[0m'
                echo '\033[32m (链接在:'/Users/$file/Desktop/${key}')\033[0m'
                ln -s /Volumes/${key} /Users/$file/Desktop/${key}
                a=1
            fi
        fi
    done
}

disk_string=$(diskutil list | grep Windows_NTFS| awk '{ print $3 }')
disk_array=(${disk_string// / })
echo ""
echo "\033[32mPlease select the number corresponding to the hard disk you want to access, the default is all\033[0m"
echo "\033[32m（请选择您要接入的硬盘对应的数字，默认为所有）\033[0m"
i=0
for var in ${disk_array[@]}
do
   echo  "\033[31m" ${i} : [${var}] "\033[0m"
   i=`expr $i + 1`
done

name=''

input_name disk_array name

if [ ! -n "$name"  ] ;
then
    for var in ${disk_array[@]}
    do
        key=${var}
        mount_drive key
    done
else
    key=${disk_array[${name}]}
    mount_drive key
fi
