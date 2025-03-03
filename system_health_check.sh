#!/bin/bash

width=$(tput cols);
consent=0;
doubleLines="";
SingleLine="";

lastUsageDisk=0;
lastUsageRAM=0;
lastUpgrades=0;

CLONE_DIR_FigletEXTRA=~/Downloads/__deeleetee___;
DEST_DIR_FigletEXTRA=/usr/share/figlet/;

function printDoubleLines(){
	if [[ $conset == 1 ]]; then
		echo "$doubleLines" | lolcat -F 0.01;
	else
		echo "$doubleLines";
	fi
}

function printStart(){
	clear -x;
	if [[ $conset == 1 ]]; then
		figlet -c -w $width -f 3d "System Health Check" | lolcat -a -s 700 -F 0.01;
	else
		echo "System Check";
	fi

	printDoubleLines;

	echo "Welcome to Qais's System Health Check!";
}

function printReport(){
	echo "";
	echo "Here are the services that we provide:"
	echo "[1] Check Disk Space";
	echo "[2] Check Memory Usage";
	echo "[3] Check Running Services";
	echo "[4] Check for Recent Updates";
	echo "[5] System Information";
	echo "[6] Help";
	echo "[7] Exit";
	echo "";
}

function printEnd(){
	echo ""
	echo "$SingleLine";
	if [[ $conset == 1 ]]; then
		echo "Thank You for using Qais's System Health Check!" | lolcat -F 0.01;
	else
		echo "Thank You for using Qais's System Health Check!";
	fi
}

function userGuide(){
	echo "# Welcome to User Guide";
	echo "For each section, you will find a description explaining how it works in case you get stuck.";
	
	echo "";
	echo "[1] Check Disk Space:";
	echo "    - Displays detailed information about your disk usage.";
	echo "    - Helps you identify free and used space on your storage devices.";

	echo "";
	echo "[2] Check Memory Usage:";
	echo "    - Provides a summary of your total, used, and available RAM.";
	echo "    - Displays a detailed memory usage report in a human-readable format.";

	echo "";
	echo "[3] Check Running Services:";
	echo "    - Lists all the running processes on your system.";
	echo "    - Shows memory usage for each process in MB for better insight.";

	echo "";
	echo "[4] Check for Recent Updates:";
	echo "    - Updates the system's package list to check for available updates.";
	echo "    - Offers an option to install upgrades if available.";

	echo "";
	echo "[5] System Information:";
	echo "    Displays detailed information about your system, including:";
	echo "      - Current date and time.";
	echo "      - System uptime.";
	echo "      - Hostname.";
	echo "      - Operating system.";
	echo "      - Kernel version.";
	echo "      - Architecture.";
}

function printHealthReport(){
	echo "";
	echo "Last Checked Disk Usage: "$lastUsageDisk"%";
	if [[ "$lastUsageDisk" -ge 80 ]]; then
		echo "Recommendation: Free up some disk space by removing unused files or programs.";
	else
		echo "Status: Disk space is sufficient.";
	fi;

	echo "";
	echo "Last Checked Memory Usage: "$lastUsageRAM%"";
	if [[ "$lastUsageRAM" -ge 75 ]]; then
		echo "Recommendation: Close unnecessary programs or upgrade your RAM.";
	else
		echo "Status: Memory usage is within acceptable limits.";
	fi;
	
	echo "";
	if [[ "$lastUpgrades" == 0 ]]; then
		echo "Upgrades not checked.";
		echo "Recommendation: Run 'sudo apt upgrade' to install updates.";
	else
		echo "Status: All packages are up to date.";
	fi;
}

for ((i=0; i<"$width"; i++)); do
	doubleLines+="=";
	SingleLine+="-";
done

if [[ -e /usr/bin/figlet && -e /usr/games/lolcat ]]; then
	conset=1;
	echo "Starting Program...";
	sleep 1s;
else
	echo "To have the best experience, it is better to install figelt and lolcat commands"
	read -p "Do you consent to us installing the necessary commands? [Y/n]" response;
	
	if [[ $response == "Y" || $response == "y" || $response == "yes" || $response == "Yes" || $response == "YES" || -z $response ]]; then
		conset=1;
		sudo apt update;
		sudo apt install figlet;
		sudo apt install lolcat;
		git clone https://github.com/xero/figlet-fonts.git ~/Downloads/__deeleetee___;
		sudo cp "$CLONE_DIR_FigletEXTRA"/* "$DEST_DIR_FigletEXTRA";
		sudo rm -r "$CLONE_DIR_FigletEXTRA";
		
		echo "";
		echo "Program will automatically start in 3 seconds";
		echo "$doubleLines";
		echo "";
	else
		echo "Commands not installed.";
		echo "";
	fi

	sleep 3s;
fi

printStart;

while true; do
	printReport;
	read -p "Enter your choice: " choice;

	echo "";
	case $choice in
		1)
			totalDisk=$(df --total | grep "total" | awk -F " " '{print $2}');
			usedDisk=$(df --total | grep "total" | awk -F " " '{print $3}');
			usageDisk=$(( (usedDisk*100)/totalDisk ));
			lastUsageDisk=$usageDisk;
			echo "You are currently using "$usageDisk"% of your disk";
			echo "Here is a detailed view for your disk usage:";
			df -h --total;
		;;
		2)
			totalRAM=$(free -t | grep "Total:" | awk -F " " '{print $2}');
			usedRAM=$(free -t | grep "Total:" | awk -F " " '{print $3}');
			usageRAM=$(( (usedRAM*100)/totalRAM ));
			lastUsageRAM=$usageRAM;
			echo "You are currently using "$usageRAM"% of your memory";
			echo "Here is a detailed view for your RAM usage:";
			free -th;
		;;
		3)
			top -E m;
		;;
		4)
			sudo apt update;
			read -p "Continue to install the commands? [Y/n]" isUpgrade;
			
			if [[ $isUpgrade == "Y" || $isUpgrade == "y" || $isUpgrade == "yes" || $isUpgrade == "Yes" || $isUpgrade == "YES" || -z $isUpgrade ]]; then
				lastUpgrades=1;
				sudo apt upgrade;
			else
				lastUpgrades=0;
				echo "";
				echo "Upgrades(if any) not installed!";
			fi
		;;
		5)
			echo "================== System Information =================="
			echo "Date and Time: $(date)"
			echo "Uptime: $(uptime -p)"
			echo "Hostname: $(hostname)"
			echo "Operating System: $(uname -o)"
			echo "Kernel Version: $(uname -r)"
			echo "Architecture: $(uname -m)"
		;;
		6)
			userGuide;
		;;
		7)
			read -p "Do you want a health report before exit? [Y/n]" isHealthReport; 
			if [[ $isHealthReport == "Y" || $isHealthReport == "y" || $isHealthReport == "yes" || $isHealthReport == "Yes" || $isHealthReport == "YES" || -z $isHealthReport ]]; then
				printHealthReport;
			fi

			printEnd;
			exit;	
		;;
		*)
			echo "Invalid Option!"	
		;;
	esac

	echo "";
	printDoubleLines;
done