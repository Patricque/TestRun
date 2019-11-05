#!/bin/bash

# Take current low-down of system.
today=`date +%Y_%m_%d__%H_%M_%S`
killall diagsd &> /dev/null
killall diags &> /dev/null

	echo "The system will now be probed in its current state."
	echo "After the probe, it will make a comparison to previous Phoenix probes to check for any device fall-out."
	echo "This probe was started: $today."
	cd /Indy/
	./diagsd
	./diags -i > /TE_Support/Scripts/archive/Fail_Tag/${today}_terminal_probes.txt
	term_file="/TE_Support/Scripts/archive/Fail_Tag/${today}_terminal_probes.txt"
	
	echo "----------------------"

	# System Serial Number + Config
	ssn_config=``
	echo "The System Serial Number and Configuration is: $ssn_config."
	# What if it's a Flash fail before the SN is written? 
	# Just check configexpected. 
	
	# ---------------------- MLB Information ---------------------- #
	
	mlb_ssn=`` # 
	mlb_smcv=`` # 
	mlb_gcon=`` # 
	mlb_chip=`` #
	mlb_boot=`` # 
	mlb_boot_lu=`` # 
	# RiserCards: MLB SN
	echo "The MLB Serial Number is: $mlb_ssn."
		# GCON Information
	echo "The GCON version is: $mlb_gcon."
		# SMC Version
		# If it's wrong, report it is wrong, and (maybe) prompt for update. 
	echo "The SMC version is: $mlb_smcv."
		# BootROM Version; Locked or Unlocked as well
		# If it's unlocked, report it as a failure, or take steps to locked. 
	echo "The bootROM version is: $mlb_boot and is is $mlb_boot_lu."
		# Chipset version
	echo "The chipset version is: $mlb_chip."
	
	# ---------------------- CPU Information ---------------------- #
	
	cpu_ssn=``
	proc_sze=``
	proc_spd=``
	
	dimm1_sn=``
	dimm1_sze=``
	dimm1_vndr=``
	
	dimm2_sn=``
	dimm2_sze=``
	dimm2_vndr=``
	
	dimm3_sn=``
	dimm3_sze=``
	dimm3_vndr=``
	
	# DIMM4 may not be present; make a catch for this. 
	dimm4_sn=``
	dimm4_sze=``
	dimm4_vndr=``
	# RiserCards: CPU SN + Processor size
	echo "The CPU SN is: $cpu_ssn."
	echo "The CPU Core count and speed are: $cpu_sze core and $cpu_spd GHz."
		# DIMM1
			# SN, size, vendor
	echo "The DIMM, populating physical slot-1 is: $dimm1_sn, $dimm1_sze, and $dimm1_vnd."
		# DIMM2
			# SN, size, vendor
	echo "The DIMM, populating physical slot-1 is: $dimm2_sn, $dimm2_sze, and $dimm2_vnd."	
		# DIMM3
			# SN, size, vendor
	echo "The DIMM, populating physical slot-1 is: $dimm3_sn, $dimm3_sze, and $dimm3_vnd."	
		# DIMM4
			# SN, size, vendor
	echo "The DIMM, populating physical slot-1 is: $dimm4_sn, $dimm4_sze, and $dimm4_vnd."
	
	


# 	Make catches for missing GFX cards; A won't always work and neither will B. 
	
	# ---------------------- GFXA Information ---------------------- #
	
	# For both A & B # 
	
	tmon_chk_file=``	
	
	# ---- #
	
	gfxa_sn=``
	gfxa_proc=``	
	gfxa_wdth=``
	gfxa_tmon=``
	gfxa_codc=``
	gfxa_gmux=``
	
	# RiserCards: GFXA SN + Processor type, speed, and width. 
		# VRAM size, vendor, tmoncheck
	echo "GFXA Serial Number is: $gfxa_sn."
	echo "GFXA Processor Type is: $gfxa_proc."	
	echo "GFXA Link-Width is: $gfxa_wdth."
	if [ $gfxa_tmon == 0 ]; then
		echo "GFXA has no failures with it's ASIC temperatures."
	else
		echo "GFXA has a fault with one (or more) of it's ASIC temperatures." 
		echo "Please review this file: $tmon_chk_file."
		# AudioCodec
	echo "GFXA's AudioCodec is: $gfxa_codc."
		# GMUX Version
	echo "GFXA's gMUX version is: $gfxa_gmux."
	
	# ---------------------- GFXB Information ---------------------- #
	
	gfxb_sn=``
	gfxb_proc=``
	gfxb_wdth=``
	gfxb_tmon=``
	gfxb_codc=``
	gfxb_gmux=``
	
	# RiserCards: GFXB SN, Processor type, speed, and width. 
		# VRAM size, vendor, tmoncheck
	echo "GFXB Serial Number is: $gfxb_sn."
	echo "GFXB Processor Type is: $gfxb_proc."	
	echo "GFXB Link-Width is: $gfxb_wdth."	
	if [ $gfxb_tmon == 0 ]; then
		echo "GFXB has no failures with it's ASIC temperatures."
	else
		echo "GFXB has a fault with one (or more) of it's ASIC temperatures." 
		echo "Please review this file: $tmon_chk_file."
		# AudioCodec
	echo "GFXB's AudioCodec is: $gfxb_codc."
		# GMUX Version
	echo "GFXB's gMUX version is: $gfxb_gmux."	
		# GMUX Version
	
	# ---------------------- IO Information ---------------------- #
	

	io_sn=``
	plx_ver=``
	tbt_busc=``
	usb_cntx=``
	udb_cnte=``
	spk_codc=``
	aud_port=``
	aud_syst=``
	blu_frwv=``
	air_mac=``
	fan_spd=``
	eth0_ip=``
	eht1_ip=``
	eth0_mac=``
	eth1_mac=``
	ill_frmv=``

	# RiserCard: IO SN
		# PLX Version
	echo "The IO Board Serial Number is: $io_sn."
	echo "The PLX Firmware Version is: $plx_ver."
	if [ $plx_ver != "03000003" ]; then
			echo "Your system's PLX version is incorrect."
			echo "The system will now update your PLX to the proper revision."
			# <PLX Update Script> #
		else
			continue
	fi
	echo "You have $tbt_busc Thunderbolt Buses."
	if [ $tbt_busc != "3" ]; then
		echo "Your system has the incorrect amount of Thunderbolt Buses."
		echo "If this is intended, please specify. (Y/N)"
		read -n 1 tbt_bus
			if [ $tbt_bus != "N" || "n" ]; then
				echo "The system will now reboot."
				# Add marker file of somesort to reiterate this failure after an attempt reboot-update. 
			else
				count=20
				

		# Thunderbolt Bus count, width, and firmware version
			# VideoPorts 1-6
		
		# USB Controllers
			# XHCI
			
			# EHCI
		
		# AudioCodec (speaker)
		
		# AudioPort Version
		
		# AudioSystem
		
		# Bluetooth
			# Firmware Version
		
		# Airport & Fan
			# Airport Locale & MAC Address
			
			# Fan Speed 
		
		# EthernetPorts
			# IP and MAC of EN1
			
			# IP and MAC of EN2
			
		# Illumination Version and count
		
		
	# ---------------------- Sensor Information ---------------------- #	
		
	# Sensor Probe + Check
		# Current + Test
		
		# Voltage + Test
		
		# Power + Test
			
			
			
			
			
			
			
			
			
	echo "----------------------"
	echo
	
# Look at previous probes and compare. 

# Call out differences and make sure they are 'real'. 

