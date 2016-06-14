# memory_check
Service Engineeting &amp; Operations Exercises
-------------------------------------------------------------------------------------------------------------------------------------
#!/bin/bash
clear
#Christian Arth D. Lingat
#get the current memory usage by parsing the string and computing
USED_MEM=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')

#help function inform the user how to use the current script
function help {
echo "INSTRUCTIONS: memory_check -w [value of warning threshold in %] -c [value of critical threshold in %] -e [email address of the recipient to receive the given info]"
echo "Example: memory_check -w 60 -c 90 -e email@mine.com"
}

#show instruction when no value or argument is provided
if [ $# -eq 0 ]; then
        echo "No value is provided";
        help
        exit 0
fi


while getopts ":w:c:e:" opt; do
        case $opt in
                w)
                warning=$OPTARG
                ;;
                c)
                critical=$OPTARG
                ;;
                e)
                email=$OPTARG
                ;;
               \?)
                echo "Invalid input: -$OPTARG:" >&2
                exit 0
                ;;
                :)
                echo "Incomplete parameter, kindly provide the required parameter."
                exit 0
                ;;
        esac
done

if [ $warning -lt $critical ]; then
                if [ $USED_MEM -lt $warning ]; then
                        echo "The current memory is in good state" | mail -s "GOOD STATE OF MEMORY" cadlingat@chikka.com
                        exit 0
                elif [[ $USED_MEM -ge $warning && $USED_MEM -lt $critical ]]; then
                        echo "The memory usage is in warning state" | mail -s "WARNING STATE OF MEMORY" cadlingat@chikka.com
                        exit 1
                elif [ $USED_MEM -ge $critical ]; then
                        echo "The memory usage is in critical state. Kindly free some memory space" | mail -s "CRITICAL MEMORY STATE OF MEMORY" cadlingat@chikka.com;
                        exit 2
                fi
else
        echo " The warning threshold($warning%) must be less than the critical threshold($critical%)";
        exit 0
fi



[root@localhost practice]# ^C
[root@localhost practice]# less memory_check
[root@localhost practice]# vim memory_check
[root@localhost practice]# ./memory_check -c 90 -w 60 -e cadlingat@chikka.com
The current memory is in good state
[root@localhost practice]# ./memory_check -c 30 -w 60 -e cadlingat@chikka.com
 The warning threshold(60%) must be less than the critical threshold(30%)
[root@localhost practice]# ./memory_check -c 90 -w 60 -e cadlingat@chikka.com
The current memory is in good state
[root@localhost practice]# vim memory_check
[root@localhost practice]# ./memory_check -c 90 -w 60 -e cadlingat@chikka.com
The current memory is in good state
[root@localhost practice]# ./memory_check -c 30 -w 60 -e cadlingat@chikka.com
 The warning threshold(60%) input must be less than the critical threshold(30%) input
[root@localhost practice]# vim memory_check
[root@localhost practice]# ./memory_check -c 30 -w 60 -e cadlingat@chikka.com
The warning threshold(60%) input must be less than the critical threshold(30%) input
[root@localhost practice]# vim memory_check
[root@localhost practice]# cat memory_check
#!/bin/bash
clear
#Christian Arth D. Lingat
#get the current memory usage by parsing the string and computing
USED_MEM=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')

#help function inform the user how to use the current script
function help {
echo "INSTRUCTIONS: memory_check -w [value of warning threshold in %] -c [value of critical threshold in %] -e [email address of the recipient to receive the given info]"
echo "Example: memory_check -w 60 -c 90 -e email@mine.com"
}

#show instruction when no value or argument is provided
if [ $# -eq 0 ]; then
        echo "No value is provided";
        help
        exit 0
fi


while getopts ":w:c:e:" opt; do
        case $opt in
                w)
                warning=$OPTARG
                ;;
                c)
                critical=$OPTARG
                ;;
                e)
                email=$OPTARG
                ;;
               \?)
                echo "Invalid input: -$OPTARG:" >&2
                exit 0
                ;;
                :)
                echo "Incomplete parameter, kindly provide the required parameter."
                exit 0
                ;;
        esac
done

if [ $warning -lt $critical ]; then
                if [ $USED_MEM -lt $warning ]; then
                        echo "The current memory is in good state"
                        exit 0
                elif [[ $USED_MEM -ge $warning && $USED_MEM -lt $critical ]]; then
                        echo "The memory usage is in warning state"
                        exit 1
                elif [ $USED_MEM -ge $critical ]; then
                        echo "The memory usage is in critical state. Kindly free some memory space"
                        exit 2
                fi
else
        echo "The warning threshold($warning%) input must be less than the critical threshold($critical%) input";
        exit 0
fi
