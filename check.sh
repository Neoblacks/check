# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: amugnier <amugnier@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/06 16:58:58 by amugnier          #+#    #+#              #
#    Updated: 2022/12/09 14:38:40 by amugnier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

#Option -h or --help
clear
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Usage: ./check.sh [OPTION] [DIR]"
	echo "Check your repo with norminette, clean it and push it"
	echo ""
	echo "Options:"
	echo "	./check.sh -h, --help		Display this help and exit"
	echo "	./check.sh -a, --all		Make and check norminette on the repo"
	echo "	./check.sh -n, --norme		Check norminette on the repo"
	echo "	./check.sh -c, --clean		Clean the repo without checking norminette"
	echo ""
	echo "Examples:"
	echo "	./check.sh -a [repo]"
	echo "	./check.sh -n [repo]"
	echo "	./check.sh -c [repo]"
	exit 0
elif [ "$1" == "-a" ] || [ "$1" == "--all" ]; then
	#choose a repo with autocompletion (tab) if the repo is not given in argument (default option)
	if [ "$2" == "" ]; then
		echo "Usage: ./check.sh [OPTION] [DIR]"
		echo "Try './check.sh --help' for more information."
		echo "Please choose a repo after the option"
		exit 1
	else
		repo=$2
	fi

	#Check if the repo is valid (exist) and if it's a directory (not a file) go make command on this repo
	if [ -d "$repo" ]; then
		norminette $repo | grep "Error" >norminette_error.txt
		cd $repo
		#Clean a.out, *.swp, *.o, *.gch
		echo "Cleaning $repo..."
		sleep 0.2
		#if Makefile exist make fclean
		if [ -f "Makefile" ]; then
			make fclean
			sleep 1
			clear
		else
			find . -name "*.o" -delete
			find . -name "*.gch" -delete
			find . -name "*.swp" -delete
			find . -name "a.out" -delete
			find . -name "*.a" -delete
			sleep 1
			clear
		fi
		#Print delimiters
		echo "----------------------------------------"
		echo "Done"
		echo "----------------------------------------"
		ls -als
		echo "----------------------------------------"
		#silence cd -
		cd - >/dev/null
		if [ -s norminette_error.txt ]; then
			echo -e "Norminette \e[31mKO\e[0m"
			cat norminette_error.txt
		else
			echo -e "Norminette \e[32mOK\e[0m"
		fi
		rm norminette_error.txt
		#Ask if the user want to push the repo
		echo "Do you want to push the repo ? (y/n)"
		read answer
		#If the answer is yes push the repo if no exit and if the answer is not yes or no ask again the question without exiting the script
		while [ "$answer" != "y" ] && [ "$answer" != "n" ]; do
			echo "Please answer with y or n"
			read answer
		done
		if [ "$answer" == "y" ]; then
			git add .
			echo "Please enter a commit message"
			read commit
			git commit -m "$commit"
			git push
			sleep 0.2
			if [ $? -eq 0 ]; then
				clear
				echo -e "Commit and push \e[32mDone\e[0m"
				exit 0
			else
				echo -e "Commit and push \e[31mFailed\e[0m"
				exit 1
			fi
		elif [ "$answer" == "n" ]; then
			echo "Thanks, bye !"
			exit 0
		fi
	else
		echo "The repo is not valid"
		echo "Usage: ./check.sh [OPTION] [DIR]"
		echo "Try './check.sh --help' for more information."
		exit 1
	fi
elif [ "$1" == "-n" ] || [ "$1" == "--norme" ]; then
	#choose a repo with autocompletion (tab) if the repo is not given in argument
	if [ "$2" == "" ]; then
		echo "Usage: ./check.sh [OPTION] [DIR]"
		echo "Try './check.sh --help' for more information."
		echo "Please choose a repo after the option"
		exit 1
	else
		repo=$2
	fi

	#Check if the repo is valid (exist) and if it's a directory (not a file) go make command on this repo
	if [ -d "$repo" ]; then
		norminette $repo | grep "Error" >norminette_error.txt
		if [ -s norminette_error.txt ]; then
			echo -e "Norminette \e[31mKO\e[0m"
			cat norminette_error.txt
		else
			echo -e "Norminette \e[32mOK\e[0m"
		fi
		rm norminette_error.txt
	else
		echo "The repo is not valid"
		echo "Usage: ./check.sh [OPTION] [DIR]"
		echo "Try './check.sh --help' for more information."
		exit 1
	fi
elif [ "$1" == "-c" ] || [ "$1" == "--clean" ]; then
	#choose a repo with autocompletion (tab) if the repo is not given in argument
	if [ "$2" == "" ]; then
		echo "Usage: ./check.sh [OPTION] [DIR]"
		echo "Try './check.sh --help' for more information."
		echo "Please choose a repo after the option"
		exit 1
	else
		repo=$2
	fi

	#Check if the repo is valid (exist) and if it's a directory (not a file) go make command on this repo
	if [ -d "$repo" ]; then
		cd $repo
		#Clean a.out, *.swp, *.o, *.gch
		echo "Cleaning $repo..."
		sleep 1
		#if Makefile exist make fclean
		if [ -f "Makefile" ]; then
			make fclean
			sleep 1
			clear
		else
			find . -name "*.o" -delete
			sleep 1
			clear
		fi
		find . -name "*.o" -delete
		find . -name "*.gch" -delete
		find . -name "*.swp" -delete
		find . -name "a.out" -delete
		find . -name "*.a" -delete
		rm norminette_error.txt
		#Print delimiters
		echo "----------------------------------------"
		echo "Done"
		echo "----------------------------------------"
		ls -als
		echo "----------------------------------------"
		#Ask if the user want to push the repo
		echo "Do you want to push the repo ? (y/n)"
		read answer
		#If the answer is yes push the repo if no exit and if the answer is not yes or no ask again the question without exiting the script
		while [ "$answer" != "y" ] && [ "$answer" != "n" ]; do
			echo "Please answer with y or n"
			read answer
		done
		if [ "$answer" == "y" ]; then
		#If the answer is yes push the repo that the user choose
			git add .
			echo "Please enter a commit message"
			read commit
			git commit -m "$commit"
			git push
			sleep 10
			if [ $? -eq 0 ]; then
				echo -e "Commit and push \e[32mDone\e[0m"
				exit 0
			else
				echo -e "Commit and push \e[31mFailed\e[0m"
				exit 1
			fi
		elif [ "$answer" == "n" ]; then
			echo "Thanks, bye !"
			exit 0
		fi
	else
		echo "The repo is not valid"
		echo "Usage: ./check.sh [OPTION] [DIR]"
		echo "Try './check.sh --help' for more information."
		exit 1
	fi
else
	echo "Usage: ./check.sh [OPTION] [DIR]"
	echo "Try './check.sh --help' for more information."
	exit 1
fi
