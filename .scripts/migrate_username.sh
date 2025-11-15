usermod -l $2 -d /home/$2 -m $1
groupmod -n $2 $1
passwd nora
sed -i -e "s/$1/$2/g" /var/lib/nixos/gid-map
sed -i -e "s/$1/$2/g" /var/lib/nixos/uid-map

