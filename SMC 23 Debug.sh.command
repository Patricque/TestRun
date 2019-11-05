#!/bin/bash

##################################################
## Thien is the best							##
## Script written by Patricque Galpin			##
##################################################

#----------------------------------------------------------------------------------#
# Reference for Intel Chips. http://www.pcidatabase.com/vendor_details.php?id=1302 #
#------||--------------------------------------------------------------------------#
#------||-------#
# Main function # 
#---------------#
comparator_function()
{
for i in "${dec_array[@]}"
do
if ((3320<$i && $i<3328)); then
	echo "This is a bad PCI0."

elif ((2693791744<$i && $i<2694053888)); then
	echo "This is a bad BR00."
	exit 0;
	
elif ((2698051584<$i && $i<2698055680)); then
	echo "This is a bad XHC1, which is USB 3.0, on the I/O Board."
	exit 0;
	
elif ((2697199616<$i && $i<2697203712)); then
	echo "This is a bad NHI1. Better known as a Falcon Ridge (Thunderbolt) chip."
	exit 0;
	
elif ((2696151040<$i && $i<2696155136)); then
	echo "This is a bad NHI2. Better known as a Falcon Ridge (Thunderbolt) chip."
	exit 0;
	
elif ((2695102464<$i && $i<2695106560)); then
	echo "This is a bad NHI0. Better known as a Falcon Ridge (Thunderbolt) chip."
	exit 0;
	
elif ((2691694592<$i && $i<2691956736)); then
	echo "This is a bad GFXA/1."
	exit 0;
	
elif ((2692087808<$i && $i<2692104192)); then
	echo "This is a bad HDAD, which is located on the GFXA/1."
	exit 0;
	
elif ((2690646016<$i && $i<2690908160)); then
	echo "This is a bad GFXB/2."
	exit 0;
	
elif ((2691039232<$i && $i<2691055616)); then
	echo "This is a bad HDAU, which is located on the GFXB/2."
	exit 0;
	
elif ((2692743168<$i && $i<2692759552)); then
	echo "This is a bad CBD0, which is located on/within the processor."
	exit 0;
	
elif ((2692759552<$i && $i<2692775936)); then
	echo "This is a bad CBD1, which is located on/within the processor."
	exit 0;
	
elif ((2692775936<$i && $i<2692792320)); then
	echo "This is a bad CBD2, which is located on/within the processor."
	exit 0;
	
elif ((2692792320<$i && $i<2692808704)); then
	echo "This is a bad CBD3, which is located on/within the processor."
	exit 0;
	
elif ((2692808704<$i && $i<2692825088)); then
	echo "This is a bad CBD4, which is located on/within the processor."
	exit 0;
	
elif ((2692825088<$i && $i<2692841472)); then
	echo "This is a bad CBD5, which is located on/within the processor."
	exit 0;
	
elif ((2692841472<$i && $i<2692857856)); then
	echo "This is a bad CBD6, which is located on/within the processor."
	exit 0;
	
elif ((2692857856<$i && $i<2692874240)); then
	echo "This is a bad CBD7, which is located on/within the processor."
	exit 0;
	
elif ((2692898816<$i && $i<2692902912)); then
	echo "This is a bad IOC4 driver, which suggests that this system needs to be re-imaged."
	exit 0;
	
elif ((2692906240<$i && $i<2692906256)); then
	echo "This is a bad Host Embedded Controller Interface (HECI) driver, which suggests that this system needs to be re-imaged, or the MLB has an issue."
	exit 0;
	
elif ((2692874240<$i && $i<2692890624)); then
	echo "This is a bad High Definition[Audio] (HDEF) driver, which suggests that this system needs to be re-imaged, or the MLB has an issue."
	exit 0;
	
elif ((17590576480256<$i && $i<17590576545792)); then
	echo "This is a bad ETH1, which is located on the I/O Board."
	exit 0;
	
elif ((17590575431680<$i && $i<17590575497216)); then
	echo "This is a bad ETH0, which is located on the I/O Board."
	exit 0;
	
elif ((2686451712<$i && $i<2686488980)); then
	echo "This is a bad Airport."
	exit 0;
	
elif ((2689597440<$i && $i<2689605632)); then
	echo "This is a bad MLB, or SSD, due to an issue with data between the two. Start with the MLB."
	exit 0;
	
elif ((2692904960<$i && $i<2692905984)); then
	echo "This is a bad ECHC1, which is USB 2.0, on the I/O Board."
	exit 0;
	
elif ((2692902912<$i && $i<2692904960)); then
	echo "This is a bad PCI-8086. The current information on this device is limited, but with the known data, it should be considered that this failure is located on the MLB."
	exit 0;
	
elif ((2692905984<$i && $i<2692906240)); then
	echo "This is a SBUS failure. This means that any device on the S-Bus could be causing a failure. Suggest starting with the CPU."
	exit 0;
	
elif ((3758071808<$i && $i<3758075904, 3758063616<$i && $i<3758067712)); then
	echo "This is a faulty XRES. Failing component/location is unknown. Suggest the CPU due to extrapolated device-address location."
	exit 0;
	
elif ((4273995776<$i && $i<4275044352)); then
	echo "This is a Advanced Programmable Interrupt Controller (APIC) failure. This component is built into the CPU. Suggesting the failure is on the CPU."
	exit 0;
	
elif ((0==$i && $i<32, 147<$i && $i<160, 192<$i && $i<224)); then
	echo "This is a bad Direct Memory Access Controller (DMAC). This component is built into the CPU. Suggesting the failure is on the CPU."
	exit 0;
	
elif ((4278190080<$i && $i<4294967296)); then
	echo "This is a faulty FWHD. Failing component/location is unknown. Suggest the CPU due to extrapolated device-address location."
	exit 0;
	
elif ((4275044352<$i && $i<4275045376)); then
	echo "This is a bad High Precision Event Timer (HPET). This component is incorporated into chipsets, suggesting the failure is on the MLB."
	exit 0;
	
elif ((32<$i && $i<34, 36<$i && $i<38, 40<$i && $i<42, 44<$i && $i<46, 48<$i && $i<50, 52<$i && $i<54, 56<$i && $i<58, 60<$i && $i<62, 160<$i && 162<$i, 164<$i && 166<$i, 168<$i && $i<170, 172<$i && $i<174, 176<$i && $i<178, 180<$i && $i<182, 184<$i && $i<186, 188<$i && $i<190, 1232<$i && $i<1234)); then
	echo "This is a faulty IPIC. Failing component/location is unknown."
	exit 0;
	
elif ((240<=$i && $i<=241)); then
	echo "The is a faulty MATH. Failing component/location is unknown. Suggest the CPU due to extrapolated device-address location."
	exit 0;
	
elif ((46<$i && $i<48, 78<$i && $i<80, 97<=$i && $i<=98, 99<=$i && $i<=100, 101<=$i && $i<=102, 103<=$i && $i<=104, 128<=$i && $i<=129, 146<=$i && $i<=147, 178<$i && $i<180, 4096<$i && $i<4112, 1024<$i && $i<1152, 2048<$i && $i<2176)); then
	echo "This is a faulty LDRC. Failing component/location is unknown. Suggest the CPU due to extrapolated device-address location."
	exit 0;
	
elif ((112<$i && $i<120)); then
	echo "This is a faulty Real Time Clock (RTC) driver. Suggest checking the MLB."
	exit 0;
	
elif ((64<$i && $i<68, 80<$i && $i<84)); then
	echo "This is a faulty TMR. This is a programmable timer, suggesting that the MLB has control over it. "
	exit 0;
	
elif ((768<$i && $i<800, 4277141504<$i && $i<4277207040)); then
	echo "This is a fault within the System Management Controller (SMC). Strongly suggest the failure is located on the SMC only."
	exit 0;
	
elif ((98<=$i && $i<=99, 102<=$i && $i<=103)); then
	echo "This is a fault within the ErrorCounter (EC). Failing component/location is unknown. Suggest the CPU due to extrapolated device-address location."
	exit 0;
fi
done
}


#-----------------------------------------------------------------------------------------#
# Creating the $mc_count variable to handle 2 or more MC_ADDR failures in one processlog. #
#-----------------------------------------------------------------------------------------#
mc_count=$(grep -c 'MC_ADDR  =' ~/Desktop/SMC23/F5KNX015F694_FAIL_2014_12_24@04_22_08/_PHOENIX_LOGS_/processlog.plog)
#F5KNW0EEF9VM_FAIL_2014_12_18\@11_43_31 - Single MC_ADDR - Works!
#F5KNV00XF694_FAIL_2014_12_10\@02_37_13 - Triple MC_ADDR
#/Desktop/SMC23/F5KNX015F694_FAIL_2014_12_24@04_22_08/_PHOENIX_LOGS_/processlog.plog
#----------------------------------------------------------------------------------------------------------------#
# Weeding out just the hexadecimal -codes- from the processlog and then stores them in the returned_grep array.  #
# Must keep 'MC_ADDR == 18bytes' #
#----------------------------------------------------------------------------------------------------------------#
returned_grep=( $(Hex= grep 'MC_ADDR  = ..................' ~/Desktop/SMC23/F5KNX015F694_FAIL_2014_12_24@04_22_08/_PHOENIX_LOGS_/processlog.plog | grep -o '= ..................' | tr -d " = x" ) ) 
#/Phoenix/Logs/processlog.plog

#--------------------------------# 
# Stores the count of the array. #
#--------------------------------#
returned_count=(${#returned_grep[@]}) 


#---------------------------------------------------------------------#
# Setting Hex to Dec ($DECn) and returning the value to the operator. | 
#                           /-----------------------------------------#
#                          /
# Multiple MC_ADDR inputs.|
#-------------------------#
many_mc()
{
	echo "----------------------------"
	echo "The found Hexadecimal(s) are: " 
	echo ${returned_grep[@]} 
	echo "----------------------------"
	while (($mc_count >= 9)); do
	DEC9=$(echo "ibase=16;${returned_grep[8]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count"
	done
	while (($mc_count >= 8)); do
	DEC8=$(echo "ibase=16;${returned_grep[7]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 1"
	done
	while (($mc_count >= 7)); do
	DEC7=$(echo "ibase=16;${returned_grep[6]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 2"
	done
	while (($mc_count >= 6)); do
	DEC6=$(echo "ibase=16;${returned_grep[5]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 3"
	done
	while (($mc_count >= 5)); do
	DEC5=$(echo "ibase=16;${returned_grep[4]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 4"
	done
	while (($mc_count >= 4)); do
	DEC4=$(echo "ibase=16;${returned_grep[3]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 5"
	done
	while (($mc_count >= 3)); do
	DEC3=$(echo "ibase=16;${returned_grep[2]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 6"
	done
	while(($mc_count >= 2)); do
	DEC2=$(echo "ibase=16;${returned_grep[1]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 7"
	done
	while (($mc_count >= 1)); do
	DEC1=$(echo "ibase=16;${returned_grep[0]}" | bc)
	let mc_count=mc_count-1
	#echo "$mc_count 8"
	done
	echo -e "The converted Hex-to-decimals are:\n$DEC1   $DEC2   $DEC3   $DEC4    $DEC5   $DEC6   $DEC7   $DEC8   $DEC9"
	echo "----------------------------"
	
	dec_array=($DEC0 $DEC1 $DEC2 $DEC3 $DEC4 $DEC5 $DEC6 $DEC7 $DEC8 $DEC9) 
	#echo -e ${dec_array[@]}
	
	comparator_function
	
	if (($mc_count > 10)); then
	echo "Escalate this nonsense to Test Engineering!!!"	
	exit 0; 	
fi
}

#------------------------------------------------------------------------------------#
# Finding the number of elements in the array to limit the redundancy in the script. #
#------------------------------------------------------------------------------------#
array_call()
{
	if (($returned_count >= 1)); then
		many_mc
	fi
}

#-----------------------#
# Single MC_ADDR input. #
#-----------------------#

if (($mc_count == 1)); then
	echo "----------------------------"
	echo "The found Hexadecimal is: " 
	echo ${returned_grep[0]} 
	DEC0=$(echo "ibase=16;${returned_grep[0]}" | bc)
	echo "----------------------------"
	echo "The converted Hex-to-decimal is: $DEC0"
	echo "----------------------------"
	comparator_function
	
fi
	
if (($mc_count > 1)); then
	array_call
	elif (($mc_count == 0)); then
	echo "-----------------------------------"
	echo "There are no SMC 23 Failures found in process.plog."
	echo "-----------------------------------"
fi