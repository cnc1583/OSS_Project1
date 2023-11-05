#! /bin/bash
echo "--------------------------
User Name: Byeong su Choi
Student Number: 12191684
[ Menu ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'release date' in 'u.item'
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"

user_choice=0
until [ $user_choice -eq 9 ]
do
	read -p "Enter your choice [ 1-9 ] " user_choice

	case $user_choice in
		1)
			echo''
			read -p "Please enter 'movie id' (1~1682): " movie_id
			echo ''
			
			cat $1 | awk -F \| -v movie_num=$movie_id 'movie_num==$1{print $0}'
			echo ''
			;;
		2)
			echo ''
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " y_or_n
			echo ''
			
			if [ $y_or_n == 'y' ]
			then
				cat $1 | sort -n | awk -F \| 'BEGIN {cnt = 0} $7 == 1 && cnt < 10 {print $1, $2; cnt += 1}'
				echo ''
			fi
			;;
		3)
			echo ''
			read -p "Please enter the 'movie id' (1~1682): " movie_id
			echo ''
			
			cat $2 | awk -v movie_id=$movie_id 'BEGIN {sum = 0; cnt = 0; average = 0} movie_id==$2 {cnt += 1; sum += $3} END {average = sum / cnt; printf "average rating of %s: %.6g", movie_id, average}'
			echo -e '\n'
			;;
		4)
			echo ''
			read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " y_or_n
			echo ''
			
			if [ $y_or_n == 'y' ]
			then
				cat $1 | sed -E 's/http.*\)//g' | awk -F \| 'BEGIN {cnt = 0} cnt < 10 {print $0; cnt += 1}'
				echo ''
			fi
			;;
		5)
			echo ''
			read -p "Do you want to get the data about users from 'u.user'?(y/n): " y_or_n
			echo ''
			
			if [ $y_or_n == 'y' ]
			then
				cat $3 | sed -e 's/M/male/g' -e 's/F/female/g' | awk -F \| 'BEGIN {cnt = 0} cnt < 10 {printf "user %s is %s years old %s %s\n", $1, $2, $3, $4; cnt += 1}'
				echo ''
			fi
			;;
		6)
			echo ''
			read -p "Do you want to Modify the format of 'release date' in 'u.item'?(y/n): " y_or_n
			echo ''
			
			if [ $y_or_n == 'y' ]
			then
				cat $1 | sed -e 's/\([0-9]\{2\}\)\-\([a-z]\{3\}\)\-\([0-9]\{4\}\)/\3\2\1/gi' -e 's/Jan/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Apr/04/g' -e 's/May/05/g' -e 's/Jun/06/g' -e 's/Jul/07/g' -e 's/Aug/08/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -e 's/Nov/11/g' -e 's/Dec/12/g' | sort -n -r| awk -F \| 'BEGIN {cnt = 0} cnt < 10 {print $0; cnt += 1}' | sort -n
				echo ''
			fi
			;;
		7)
			echo ''
			read -p "Please enter the 'user id' (1~943): " user_id
			echo ''

			cat $2 | sort -k 2 -n | awk -v user_id=$user_id 'user_id==$1 {printf "%s|", $2}' | sed 's/.$//'
			echo -e '\n'
			
			list=$(cat $2 | sort -k 2 -n | awk -v user_id=$user_id 'BEGIN {cnt = 0} user_id==$1 && cnt < 10 {print $2; cnt += 1}')	
			
			for var in $list
			do
				cat $1 | awk -F \| -v comp=$var 'comp==$1 {printf "%s|%s\n", $1, $2}'
			
			done
			echo ''
			;;
		8)
			echo ''
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " y_or_n
			echo ''
			if [ $y_or_n == 'y' ]
			then
				touch temp.txt
				user_list=$(cat $3 | awk -F \| '$2>19 && $2<30 && $4~"programmer"{print $1}')

				for var in $user_list
				do
					cat $2 | awk -v user_id=$var '$1==user_id{print $2, $3}' >> temp.txt
				done

				for var in $(seq 1 1682)
				do
					cat temp.txt | awk -F ' ' -v movie_id=$var 'BEGIN{sum=0; cnt=0; avg=0} $1==movie_id{cnt+=1; sum+=$2} END{if (cnt != 0) {avg=sum/cnt; printf "%d %0.6g\n", movie_id, avg}}'
					
				done
				
				rm temp.txt
							
			fi
			echo ''

			;;
		9)
			echo "Bye!"
			break
			;;
		*)
			echo "Invalid Choice"
			;;
	esac
done
