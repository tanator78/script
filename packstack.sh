#!/bin/bash
#On initialise les variables
compteur = 0

#On demande à l'utilisateur de renseigner l'adresse et le port de son proxy
#Il peut le laisser vide si il n'utilise pas de proxy
read -p "Veuillez saisir l'adresse Ip du Proxy: " PROXY_URL
read -p "Veuillez saisir le port du Proxy: " PROXY_PORT

ip a
read -p "Veuillez saisir le nom de l'interface a configurer: " INTERFACE

#Le script va ensuite configurer le proxy
echo "proxy=http://$PROXY_URL:$PROXY_PORT" >> /etc/yum.conf
export http_proxy=http://$PROXY_URL:$PROXY_PORT
export https_proxy=https://$PROXY_URL:$PROXY_PORT

#Le script va ensuite procéder aux mises a jours et a l'installation de PackStack
yum -y update
setenforce 0 
systemctl stop firewalld 
systemctl disable firewalld 
yum -y install https://rdoproject.org/repos/rdo-release.rpm 
yum -y install centos-release-openstack-mitaka
yum -y update 
yum -y install openstack-packstack
echo " NM_CONTROLLED= 'no' " >> /etc/sysconfig/network-scripts/ifcfg-$INTERFACE
systemctl stop NetworkManager
systemctl disable NetworkManager
yum install python-pip

#On va ensuite générer un script permettant de configurer PackStack avant son installation
packstack --gen-answer-file=~/answer.cfg
#Puis on va demander a l'utilisateur si il compte procéder a une installation basique
while [ "$compteur" != "1" ]
do
read -p "Voulez-vous procéder a une installation par défaut ? Y/N " reponse
  if [ $reponse = "Y" ]
    #Si l'utilisateur choisit de procéder a une installation par défaut, le script va lancer l'installation sans modification du fichier
    then packstack --answer-file=answer.cfg
         let "compteur+=1"
  elif [ $reponse = "N" ]
    #Si l'utilisateur choisit de procéder a une installation personnalisée le script va lui demander de modifier le fichier de configuration
    then echo "Veulliez modifier le fichier answer.cfg puis lancer la commande: packstack --answer-file=answer.cfg"
         let "compteur+=1"
  else 
     echo "Réponse incorrecte veuillez réessayer!"
  fi
done
