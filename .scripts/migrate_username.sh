subgid=$(< /etc/subgid)
subuid=$(< /etc/subuid)

usermod -l $2 -d /home/$2 -m $1
groupmod -n $2 $1
passwd $2
sed -i -e "s/$1/$2/g" /var/lib/nixos/gid-map
sed -i -e "s/$1/$2/g" /var/lib/nixos/uid-map

subgid=${subgid//"$1"/"$2"}
subuid=${subuid//"$1"/"$2"}

printf '%s' "$subgid" > /etc/subgid
printf '%s' "$subuid" > /etc/subuid