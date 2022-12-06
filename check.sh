# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: amugnier <amugnier@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/06 16:58:58 by amugnier          #+#    #+#              #
#    Updated: 2022/12/06 17:37:17 by amugnier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

#Option -h or --help
clear
if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
	echo "Usage: ./check.sh [OPTION] [FILE]"
	echo "Check if the repo is valid to push the project "
	echo " "
	echo "Options:"
	echo "-h, --help	Display this help and exit"
	echo "-n, --norme	Check if the norminette is valid"
	echo "-c, --clean	clean a.out, *.swp, *.o, *.gch"
	echo "-a, --all	Check if the norminette is valid and clean a.out, *.swp, *.o, *.gch" #Default option
	exit 0
elif [ "$1" == "-a" ] || [ "$1" == "--all" ]; then
	#choose a repo with autocompletion (tab) if the repo is not given in argument (default option)
	if [ "$2" == "" ]
	then
		echo "Usage: ./check.sh [OPTION] [FILE]"
		echo "Try './check.sh --help' for more information."
		echo "Please choose a repo after the option"
		exit 1
	else
		repo=$2
	fi

	#Check if the repo is valid (exist) and if it's a directory (not a file) go make command on this repo
	if [ -d "$repo" ]
	then
		cd $repo
		norminette | grep "Error" > ~/Documents/Script/Clean/norminette_error.txt
		#Check if the norminette is valid
		if [ -s ~/Documents/Script/Clean/norminette_error.txt ]
		then
			echo -e "Norminette \e[31mKO\e[0m"
			cat ~/Documents/Script/Clean/norminette_error.txt
			exit 1
		else
			echo -e "Norminette \e[32mOK\e[0m"
			rm ~/Documents/Script/Clean/norminette_error.txt
		fi
		#Clean a.out, *.swp, *.o, *.gch
		echo "Cleaning $repo..."
		sleep 1
		#if Makefile exist make fclean
		if [ -f "Makefile" ]
		then
			make fclean
			sleep 1
			clear
		else
			find . -name "*.o" -delete
			sleep 1
			clear
		fi
		find . -name "*.gch" -delete
		find . -name "a.out" -delete
		find . -name "*.swp" -delete
		rm -rf norminette_error.txt
		#Print delimiters
		echo "----------------------------------------"
		echo "Done"
		echo "----------------------------------------"
		ls -als
		echo "----------------------------------------"
	else
		echo "The repo is not valid"
		exit 1
	fi
else
	echo "Usage: ./check.sh [OPTION] [FILE]"
	echo "Try './check.sh --help' for more information."
	exit 1
fi
