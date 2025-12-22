OLD=$1
NEW=$2

echo "About to change username from '$OLD' to '$NEW'"
read -p "Is this correct? (y/N) " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled"
    exit 1
fi

subgid=$(< /etc/subgid)
subuid=$(< /etc/subuid)

usermod -l $NEW -d /home/$NEW -m $OLD
groupmod -n $NEW $OLD
passwd $2
sed -i -e "s/$OLD/$NEW/g" /var/lib/nixos/gid-map
sed -i -e "s/$OLD/$NEW/g" /var/lib/nixos/uid-map

subgid=${subgid//"$OLD"/"$NEW"}
subuid=${subuid//"$OLD"/"$NEW"}

printf '%s' "$subgid" > /etc/subgid
printf '%s' "$subuid" > /etc/subuid

echo "Username successfully changed from $OLD to $NEW"
