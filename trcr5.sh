#!/bin/bash

# Variables :

ttl=0
let ttl++
min=6

# On demande l'adresse a cibler avec traceroute :

echo "Tapez une adresse :"
read addr
host=$(host $addr | sed -n "1p" | awk '{printf $4}')

	# sed -n "1p" --> Ne prend que la première ligne
	# awk '{printf $4}' -->  Ne prend que le 4e argument.

# Les 3 commandes pour lancer traceroute sur les ports différent :

	ICMP=$(traceroute -f $ttl -m $ttl -q 1 -n -I -A $addr)
	UDP=$(traceroute -f $ttl -m $ttl -q 1 -n -U -A $addr)
	TCP=$(traceroute -f $ttl -m $ttl -q 1 -n -T -A $addr)

# Les 3 commandes de découpage :

	decoupage1=$(echo "$UDP" | cut -d" " -f 11,12,13 | sed -r "s/ /;/g" | sed -r "s/;//4")
	decoupage2=$(echo "$TCP" | cut -d" " -f 11,12,13 | sed -r "s/ /;/g" | sed -r "s/;//4")
	decoupage3=$(echo "$ICMP" | cut -d" " -f 11,12,13 | sed -r "s/ /;/g" | sed -r "s/;//4")

	# cut -d" " -f 11,12,13 --> Ne prend que les champs 11, 12, 13, délimité par des espaces. Sous la forme : Bond;@IP;AS
	# sed -r "s/ /;/g'" --> Remplace les espaces par des virgules pour toutes les lignes.
	# sed -r "s/;//4" -->  Remplace la 4e virgule par rien.

# Les 3 commande de comptage des étoiles :

	count1=$(echo "$decoupage1" | wc -m)
	count2=$(echo "$decoupage2" | wc -m)
	count3=$(echo "$decoupage3" | wc -m)

	# wc -m --> Compte le nombre de caractère dans le résultat de la commande.  

# Boucle qui compare l'adresse IP du routeur passé à celle de destination pour la stopper quand on arrive a bon port :

while [ "$host" != "$ttladdr" ]
do
let ttl++
	ICMP=$(traceroute -f $ttl -m $ttl -q 1 -n -I -A $addr)
	UDP=$(traceroute -f $ttl -m $ttl -q 1 -n -U -A $addr)
	TCP=$=$(traceroute -f $ttl -m $ttl -q 1 -n -T -A $addr)

		decoupage1=$(echo "$UDP" | cut -d" " -f 11,12,13 | sed -r "s/ /;/g" | sed -r "s/;//4")
        	decoupage2=$(echo "$TCP" | cut -d" " -f 11,12,13 | sed -r "s/ /;/g" | sed -r "s/;//4")
        	decoupage3=$(echo "$ICMP" | cut -d" " -f 11,12,13 | sed -r "s/ /;/g" | sed -r "s/;//4")

		count1=$(echo "$decoupage1" | wc -m)
		count2=$(echo "$decoupage2" | wc -m)
		count3=$(echo "$decoupage3" | wc -m)
		echo "$decoupage1"
			if [ "$count1" -lt "$min" ] # Si le résultat de count1 < 5 on change de protocole.
        			then echo "UDP"
                			if [ "$count2" -lt "$min" ] # Si le résultat de count2 < 5 on change de protocole.
                        			then echo "TCP"
                                			if [ "$count3" -lt "$min" ]
                                        			then echo "ICMP"
                                			else 	echo "$deoupage3"
                                        				ttladdr=$(echo "$ICMP" | sed -r "s/^ //g" | awk -F " " '{print $12}')
                                			fi
                			else	echo "$decoupage2"
              					ttladdr=$(echo "$TCP" | sed -r "s/^ //g" | awk -F " " '{print $12}')
        				 fi

			else echo "$decoupage1"
        			ttladdr=$(echo "$UDP" | sed -r "s/^ //g" | awk -F " " '{print $12}')

			fi

done
exit 1
#oui oui
#zobizoba
#mescouilles