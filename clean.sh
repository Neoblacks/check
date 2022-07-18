# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    clean.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: amugnier <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/07/17 12:57:30 by amugnier          #+#    #+#              #
#    Updated: 2022/07/18 10:18:37 by amugnier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Debut du script

return_value=0
reponse_yes="yes"
reponse_non="no"

#output_norminette=$(norminette $repo/* | grep -c "Error")

# Suppression des fichiers

echo "Quel repo souhaitez vous traiter ?"
echo " "
read repo
echo "$repo trouve"

echo "Suppression des fichiers a.out et .swp"
echo " "
echo "#############################################"
echo " "

find $repo/ -type f \( -name "a.out" -o -name "*.swp" \) -delete -print

echo " Tous les fichiers a.out et .swp ont ete supprimes"
echo " "
echo "#############################################"
echo " "

sleep 1

# Passage de la norminette

echo "Passage de la norminette"
echo " "
echo "#############################################"
echo " "

norminette $repo/*

if [[ $output_norminette -le $return_value ]]
then
	echo " "
	echo "BRAVO LA NORME EST VALIDEE"
	echo " "
else
	echo " "
	echo "MIAAAOOOOOOOOUUU TA NORME EST PAS BONNE !"
	echo " "
fi 

echo "#############################################"
echo " "
echo "Norminette terminee"
echo " "
echo "#############################################"
echo " "

sleep 1

# Verification des main

echo "Verification des main"
echo " "
echo "#############################################"
echo " "
cd $repo/
output_main=$(cat */* | grep -o -c "main")

if [[ $output_main -le $return_value ]]
then
    echo "Aucun main detectes souhaitez vous commit et push ?"
	read reponse
	if [ "$reponse" = "$reponse_yes" ]
	then
		echo "Vous avez repondu oui."
		echo " "
		echo "Git commit en cours"
		echo " "
		git add $repo/*
		sleep 1
		echo "Quel message de commit souhaitez vous mettre ?" 
		read commit
		git commit -m "$commit"
		sleep 2
		git push
		echo " "
		echo "Le push est termine. Fin du script"
	elif [ "$reponse" = "$reponse_non" ]
	then
		echo "Vous avez repondu non. Fin du script"
	else
		echo "Reponse inconnu. Fin du script"
	fi
else
    echo "Attention des main sont detectes ! Souhaitez vous push avec les mains ?"
	echo " "
	cat */* | grep -o -l "main" */*
	read reponse
	if [ "$reponse" = "$reponse_yes" ]
	then
		echo "Vous avez repondu oui."
		echo " "
		echo "Git commit en cours"
		echo " "
		git add .
		sleep 1
		echo "Quel message de commit souhaitez vous mettre ?" 
		read commit
		git commit -m "$commit"
		sleep 2
		git push
		echo " "
		echo "Le push est termine. Fin du script"
	elif [ "$reponse" = "$reponse_non" ]
	then
		echo "Vous avez repondu non. Fin du script"
	else
		echo "Reponse inconnu. Fin du script"
	fi
fi
