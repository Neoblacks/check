# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    clean.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: amugnier <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/07/17 12:57:30 by amugnier          #+#    #+#              #
#    Updated: 2022/07/17 16:04:12 by amugnier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Debut du script

return_value=0

output_main=$(cat */* | grep -c "main")
output_norminette=$(norminette | grep -c "Error")

# Suppression des fichiers
echo "Suppression des fichiers a.out et .swp"
echo " "
echo "#############################################"
echo " "

find . -type f \( -name "a.out" -o -name "*.swp" \) -delete -print

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

norminette 

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

if [[ $output_main -le $return_value ]]
then
    echo "Aucun main detecter souhaitez vous commit et push ?"
else
    echo "Attention des main sont detecter, soyez sur d'en avoir besoin avant de push"
	echo " "
	cat */* | grep -o -l "main" */*
fi
