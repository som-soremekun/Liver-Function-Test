#!/bin/bash
the_file=$1
for chr_num in {1..22}
do
  awk -v var="$chr_num" '{ if ($1==var) print $2"\t"$4 }' $the_file | sort -k2 -g > tmp
    declare -A posPval
    declare -a posArray
    declare -A blacklist
    while read pos pval
    do
        posPval[$pos]=$pval
        posArray+=($pos)
    done < tmp
    for key in ${!posArray[@]}
    do
        ## GET THE POSITION FROM THE ARRAY
        position=${posArray[$key]}
        if [ -z $position ]
        then
            :
        else
            echo -e "$chr_num:$position" #\t${posPval[$position]}"
            min=$(( $position - 500000 ))
            max=$(( $position + 500000 ))
            for dict in ${!posPval[@]}
            do
                if [[ -z ${posPval[$dict]} ]]
                then
                    :
                else
                    if (( $dict >= $min && $dict <= $max && $dict != $key ))
                   then   
                      unset posPval[$dict]
                   blacklist[$dict]=1
                    else
                        :
                    fi
                fi
            done
            do
                if [[ -z ${blacklist[${posArray[$item]}]} ]]
                then
                    :
                else
                    unset posArray[$item]
                fi
            done
fi
    done
    unset posArray[@]
    unset posPval[@]
    rm tmp
done
