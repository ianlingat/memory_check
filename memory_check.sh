#!/bin/bash
#Christian Arth D. Lingat
clear
#get the current date and time with a format of YYYYMMDD HH:MM
DATE=`date +%Y%m%d" "%H:%M`
#get the current memory usage by parsing the string and computing
USED_MEM=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')
#show instruction when no value or argument is provided
if [ $# -eq 0 ]; then
        echo "No value is provided";
        echo "INSTRUCTIONS: memory_check -w [value of warning threshold in %] -c [value of critical threshold in %] -e [email address of the recipient to receive the given info]"
        echo "Example: memory_check -w 60 -c 90 -e email@mine.com"
        exit 0
fi

while getopts ":w:c:e:" opt; do
        case $opt in
                w)
                warning=$OPTARG;;
                c)
                critical=$OPTARG;;
                e)
                email=$OPTARG;;
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
                        echo "The current memory is in good state" | mail -s "$DATE CURRENT MEMORY IS IN GOOD STATE" $email
                        exit 0
                elif [[ $USED_MEM -ge $warning && $USED_MEM -lt $critical ]]; then
                        echo "The memory usage is in warning state" | mail -s "$DATE CURRENT MEMORY IS IN WARNING STATE" $email
                        exit 1
                elif [ $USED_MEM -ge $critical ]; then
                        ( ps aux | sort -nk +4 | tail ) > /home/monitor/src/TOP10
                        ( mail -s "$DATE memory check - critical" $email ) < /home/monitor/src/TOP10
                        exit 2
                fi
else
        echo "The warning threshold($warning%) input must be less than the critical threshold($critical%) input";
        exit 0
fi
