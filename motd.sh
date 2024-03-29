#!/bin/bash

clear

function color (){
  echo "\e[$1m$2\e[0m"
}

function findDeviceModel (){
  deviceName=""
  local deviceModel=$(tr -d '\0' < /sys/firmware/devicetree/base/model)
  local hostName=$(hostname)

  if [ $hostName ]; then
    deviceName="$deviceModel - $hostName"
  else
    deviceName="$deviceModel"
  fi
}

deviceColor="30;48;5;249"
greetingsColor="30;38;5;103"
userColor="30;48;5;67"
me=$(logname)
findDeviceModel

# Device Info
deviceLabel=" $(color $deviceColor " $deviceName ")"

# Greetings
me="$(color $userColor " $me ")"
greetings="$(color $greetingsColor "   ⮞ Welcome »") $me\n"
greetings="$greetings$(color $greetingsColor "   ⮞ $(date +"%a %b %d %Y, %I:%M:%S %p")")\n"

# OS
greetings="$greetings$(color $greetingsColor "   ⮞ $(uname -srm)")"


function sec2time (){
  local input=$1

  ((days=input/86400))
  ((input=input%86400))
  ((hours=input/3600))
  ((input=input%3600))
  ((mins=input/60))

  local daysPlural="s"
  local hoursPlural="s"
  local minsPlural="s"

  if [[ $days -eq 0 ||  $days -eq 1 ]]; then
    daysPlural=""
  fi
  if [[ $hours -eq 0 || $hours -eq 1 ]]; then
    hoursPlural=""
  fi
  if [[ $mins -eq 0 || $mins -eq 1 ]]; then
    minsPlural=""
  fi
  echo "$days day$daysPlural $hours hr$hoursPlural $mins min$minsPlural"
}
statsLabelColor="30;38;5;143"
bulletColor="30;38;5;241"
infoColor="30;38;5;74"
dimInfoColor="37;0;2"
me=$(logname)


# Last Login
read loginIP loginDate <<< $(last $me --time-format iso -2 | awk 'NR==1 { print $3,$4 }')
if [[ $loginDate == *T* ]]; then
  login="$(date -d $loginDate +"%a %b %d %Y, %I:%M %p") $(color $dimInfoColor "» $loginIP")"
else
  # First Login
  login="None"
fi

# Stats
label1="$login"
label1="$(color $statsLabelColor "Last") $(color $bulletColor "····")$(color $statsLabelColor "›") $(color $infoColor "$label1")"

label2="$(vcgencmd measure_temp | cut -c "6-9")°C"
label2="$(color $statsLabelColor "Temp") $(color $bulletColor "···")$(color $statsLabelColor "›") $(color $infoColor $label2)"

uptime="$(sec2time $(cut -d "." -f 1 /proc/uptime))"
uptime="$uptime $(color $dimInfoColor "» $(date -d "@"$(grep btime /proc/stat | cut -d " " -f 2) +"%m-%d-%y %H:%M")")"

label3="$uptime"
label3="$(color $statsLabelColor "Uptime") $(color $bulletColor "··")$(color $statsLabelColor "›") $(color $infoColor "$label3")"

label4="$(awk '{print $1}' /proc/loadavg)"
label4="$(color $statsLabelColor "Load") $(color $bulletColor "···")$(color $statsLabelColor "›") $(color $infoColor $label4)"

label5="$(df -h ~ | awk 'NR==2 { printf "%sB / %sB \e[30;38;5;144m» Free: %sB\e[0m",$3,$2,$4; }')"
label5="$(color $statsLabelColor "Disk") $(color $bulletColor "····")$(color $statsLabelColor "›") $(color $infoColor "$label5")"

label6="$(/bin/ls -d /proc/[0-9]* | wc -l)"
label6="$(color $statsLabelColor "Procs") $(color $bulletColor "··")$(color $statsLabelColor "›") $(color $infoColor $label6)"

label7="$(free -h --si | awk 'NR==2 { printf "%sB / %sB \e[30;38;5;144m» Free: %sB\e[0m",$3,$2,$4; }')"
label7="$(color $statsLabelColor "Memory") $(color $bulletColor "··")$(color $statsLabelColor "›") $(color $infoColor "$label7")"

label8="$(hostname -I)"
label8="$(color $statsLabelColor "IP") $(color $bulletColor "·····")$(color $statsLabelColor "›") $(color $infoColor $label8)"

# Print
# Print
echo -e "\n$deviceLabel"
echo -e "\n$greetings"
echo
echo -e "                                                         $label2\r   $label1"
echo -e "                                                         $label4\r   $label3"
echo -e "                                                         $label6\r   $label5"
echo -e "                                                         $label8\r   $label7"
echo

