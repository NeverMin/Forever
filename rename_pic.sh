#!/bin/bash

# tested in WSL2
# Doc
# https://docs.microsoft.com/zh-cn/windows/wsl/

# data sample
# wechat_nickname1,2022/2/24 17:25:28,student_name1,wechat_nickname1-2022/02/24 17:25:28.jpeg,wechat_nickname1-2022/02/24 17:26:28.jpeg,,,,,,,,,,,,,,,,,,,,,,,,,,
# cat 0223.csv | while read line; do student_name=$(echo $line | awk -F"," '{print $3}') ; echo $student_name ; file_student_name=$(echo $line | awk -F"," '{print $4}' | sed -e 's:/:-:g' -e 's/:/_/g') ; ls -lh "./attachment/$file_student_name" ; done
# cat 0223.csv | while read line; do student_name=$(echo $line | awk -F"," '{print $3}') ; echo $student_name ; first_pic=$(echo $line | awk -F"," '{print $4}' | sed -e 's:/:-:g' -e 's/:/_/g') ; second_pic=$(echo $line | awk -F"," '{print $5}' | sed -e 's:/:-:g' -e 's/:/_/g') ; ls -lh "./attachment/$first_pic" ; [ "$second_pic" != "" ] && ls "./attachment/$second_pic" ; done
# wechat_nickname1-2022-02-24 17_25_28.jpeg
# wechat_nickname1-2022/02/24 17:25:28.jpeg

# more picture
# test_line='wechat_nickname1,2022/2/24 17:25:28,student_name1,wechat_nickname1-2022/02/24 17:25:28.jpeg,wechat_nickname1-2022/02/24 17:26:28.jpeg,wechat_nickname1-2022/02/24 17:27:28.jpeg,wechat_nickname1-2022/02/24 17:28:28.jpeg,,,,,,,,,,,,,,,,,,,,,,,,'
# pic_name=( $(echo $test_line | awk -F"," '{ for( n=4 ; n<=NF-1 ; n++ ) printf $n"_"}') )
# "wechat_nickname1-2022/02/24 17:25:28.jpeg" "wechat_nickname1-2022/02/24 17:26:28.jpeg" "wechat_nickname1-2022/02/24 17:27:28.jpeg" "wechat_nickname1-2022/02/24 17:28:28.jpeg" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
# echo "SUN,2022/3/1 19:02:17,student_name2,,收集结果-student_name2-1-2022/03/01 19:02:17.jpeg,收集结果-student_name2-2-2022/03/01 19:02:17.jpeg,收集结果-student_name2-3-2022/03/01 19:02:17.jpeg,收集结果-student_name2-4-2022/03/01 19:02:17.jpeg,,,,,,,,,,,,,,,,,,,,,,," | awk -F"," '{for(n=1;n<=NF-1;n++) printf $n"_"}'

OLD_IFS=$IFS ; IFS="_" ;
work_dir=$PWD

excel_file_name=$work_dir/'0307.csv'
attachment_source=$work_dir/'attachment/'
attachment_target=$work_dir/'target/'

# rename file match student name from excel
if [[ ! -d "$attachment_target" ]]; then
	mkdir $attachment_target ;
else
	IFS=$OLD_IFS ;
	exit 0 ;
fi

cat $excel_file_name | while read line; do 
	student_name=$(echo $line | awk -F"," '{print $3}') ; 

	# n = picture start number :
	# space causes array delimiter errors: IFS="_"
	pic_name=( $(echo -n $line | awk -F"," '{ for( n=4 ; n<=NF-1 ; n++ ) printf $n"_"}') ) ;

	for (( i = 0; i < ${#pic_name[@]}; i++ )); do
		pic_filename="$(echo ${pic_name[$i]} | sed -e 's:/:-:g' -e 's/:/_/g')" ;

		if [[ "$pic_filename" != "" ]]; then
			cp "${attachment_source}$pic_filename" "${attachment_target}${student_name}.$((i+1)).${pic_filename#*.}" || echo "$student_name : $first_pic" ;
		else
			break ;
		fi

	done
done

# prefix the file name with the student number：
student_name=(student_name1 student_name2 student_name3 ...student_nameN)
# The elements of the array need to be sorted by Chinese Pingyin

cd $attachment_target
for (( x = 0; x < ${#student_name[@]}; x++ )); do
	ls -1 | while read file_name; do
		if [[ $( echo -n ${file_name%%.*}) == ${student_name[x]} ]]; then
			mv $file_name "F$((x+1))$file_name" ;
		fi
	done
done

cd -
IFS=$OLD_IFS
