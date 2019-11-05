#!/bin/bash 

#############################################
# All-encompassing Debugging Tool. #
# Created by: Patricque Galpin				#
# Inspired by: Sir Jazael Ramos				#
# Built: 2/25/2015                          #
#############################################

#-------------------------------------------------------------------#
# This is designed to take user input and run the selected routine. #
#-------------------------------------------------------------------#

#--------------------#
# Confirmation step. #
#--------------------#

setup_confirmation()
	{
echo -n "Would you like to run the Debug Tool? (Y/N) "
read -n 1 begin
sleep 5
if [ "$begin" == "n" ] || [ "$begin" == "N" ]; then
		echo
		echo "Quitting application."
		exit 0;
elif [ "$begin" == "y" ] || [ "$begin" == "Y" ]; then 
		echo
		echo "Starting the tool, please standy."
		echo "--------------------"
		/Volumes/5125348802/Parser/Phoenix_Parser.command
		echo "--------------------"
		echo
		echo "ProcessLog Parsed."
		sleep 1
		echo "Fetching relavant information..."
		testname=$(grep "PACKAGE=" /private/var/root/Desktop/processlog_resultfile.txt)
		testid=$(grep "TID=" /private/var/root/Desktop/processlog_resultfile.txt)
		testname=${testname#*=}
		testid=${testid#*=}
		echo
		echo -ne "The found fail is for \033[1m"$testname":"$testid"\033[0m. Is this correct? (Y/N) " 
		read -n 1 confirm
		echo
		echo "$testname"
			if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
				test_filter

			elif [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
				echo
				echo -e "Please enter TestPackage name you wish to setup and hit 'Enter': "
				read testname
				echo -e "Please enter the Test ID for \033[1m"$testname":\033[0m "
				read testid
				echo -e "You entered \033[1m'"$testname":"$testid"'\033[0m. Is this correct? (Y/N) "
				read -n 1 confirmation
				echo

				if [ "$confirmation" == "n" ] || [ "$confirmation" == "N" ]; then
					echo -e "If you would like Help with which tests can be entered, please type \033[1m'Help'\033[0m. Otherwise, please just hit \033[1m'Enter'\033[0m to return to the top-level."
					read confirmation
						if [ "$confirmation" == "Help" ] || [ "$confirmation" == "help" ]; then
							sleep 1
							help1
						elif [ "$confirmation" != "Help" ] || [ "$confirmation" != "help" ]; then
							echo "Entered information did not meet internal parameters, please retry."
							sleep 1
							echo
							setup_confirmation
						fi

				elif [ "$confirmation" == "y" ] || [ "$confirmation" == "Y" ]; then
				#echo -n "Was this failure a Test Package failure, or a Hang Failure? (T)est/(H)ang) "
				#read -n 1 testenv
				test_filter
				else 
				echo
				echo "Entered information did not meet internal parameters, please retry."
				sleep 1
				setup_confirmation
				fi
				 
			else 
				no_test


			fi
		else 
		echo 
		no_test	
fi
	}

#---------------------#
# No Setup Parameters #
#---------------------#
no_param()
	{
		echo 
		echo "No special parameters are needed run this test."
		sleep 1
		echo "Returning to top-level..."
		sleep 3
		echo -e "Good-bye!\n"
		setup_confirmation
		exit 0;
	}
	
#---------------------#
# Improper Test Input #
#---------------------#
no_test()
	{
		echo 
	    echo "Entered information did not meet internal parameters, please retry."
		echo "Returning to top-level..."
		sleep 3
		echo -e "Good-bye!\n"
		startup
		exit 0;
	}

#-------------#
# Test Filter #
#-------------#

test_filter()
	{
#if [ "$testenv" == "T" ] || [ "$testenv" == "t" ]; then
	echo
	os_test_setup
	exit 0;
#elif [ "$testenv" == "H" ] || [ "$testenv" == "h" ]; then
#	echo
#	efi_hang_setup
#	exit 0;
#else
#	echo 
#	echo "Entered information did not meet internal parameters, please retry."
#	setup_confirmation
#fi
	}


#------------#
# Hang setup #
#------------#

efi_hang_setup()
	{
	echo -n "Was "$testname":"$testid" a Hang during EFI? (Y/N) "
	read -n 1 efihang
if [ "$efihang" == "Y" ] || [ "$efihang" == "y" ]; then
	echo
	echo "EFI Tests may not be run outside of RunIn. Please, debug this system to your best knowledge and return it to production."
	exit 0; 
elif [ "$efihang" == "N" ] || [ "$efihang" == "n" ]; then
	echo
	echo "Assuming failure is an OS Hang... redirecting"
	sleep 1
	os_hang_setup
	exit 0;
fi
	}
	
#----------------#
# OS Test setup  #
# It's very long #
#----------------#

os_test_setup()
	{
#--------------#
# Array setups #
#--------------#
# --- Current --- #
sensorarray1=( 'Current@IC0C - CPU Core low-side current (Amps)\n''Current@IC0S - CPU VSA low-side current (Amps)\n''Current@ICTR - CPU Riser 12V high-speed avg 0.1ms high-side current (Amps)\n''Current@IG0C - GFX-A Core low side current (Amps)\n''Current@IG0R - GFX-A Riser 12V high-speed avg 0.1ms high-side current (Amps)\n''Current@IG0S - GFX-A VDDCI low-side current (Amps)\n''Current@IG1C - GFX-B Core low-side current (Amps)\n''Current@IG1R - GFX-B Riser 12V high-speed avg 0.1ms high side current (Amps)\n''Current@IG1S - GFX-B VDDCI low-side current (raw ADC)\n''Current@IH0R - SSD 3V3 low side current (Amps)\n''Current@II0R - I/O Board 12V high-speed avg 0.1ms high side current (Amps)\n''Current@IMTR - Memory 1V5 high-side current' )

# --- Temperature --- #
sensorarray2=( 'Temperature@TA0p - Ambient 0 on MLB raw temp (DegC)\n''Temperature@TA1p - Ambient 1 on MLB cooked temp(DegC)\n''Temperature@TA2p - Ambient 2 on MLB cooked temp (DegC)\n''Temperature@TC0p - CPU Proximity cooked temp (DegC)\n''Temperature@TC1p - CPU VR Proximity raw temp (DegC)\n''Temperature@TCXr - CPU Max Package Core relative raw temp (PECI) (DegC)\n''Temperature@Te0t - PCIe Switch Diode raw temp (DegC)\n''Temperature@TG0d - GFX-A Die raw temp (DegC)\n''Temperature@TG0p - GFX-A Proximity raw temp (DegC)\n''Temperature@TG0r - GFX-A VR Proximity raw temp (DegC)\n''Temperature@TG1d - GFX-B Die raw temp (DegC)\n''Temperature@TG1p - GFX-B Proximity raw temp (DegC)\n''Temperature@TG1r - GFX-B VR Proximity raw temp (DegC)\n''Temperature@TI0p - I/O Board Proximity raw temp (DegC)\n''Temperature@TI0t - Thunderbolt Proximity cooked temp (DegC)\n''Temperature@TI1p - 5V/3V3 VR Proximity raw temp (DegC)\n''Temperature@TM0p - DIMM 0/1 Top Proximity raw temp (DegC)\n''Temperature@Tm0p - MLB Proximity 0 raw temp (DegC)\n''Temperature@TM0r - DIMM 0/1 VR Proximity cooked raw temp (DegC)\n''Temperature@TM1p - DIMM 2/3 Top Proximity raw temp (DegC)\n''Temperature@TM1r - DIMM 2/3 VR Proximity raw temp (DegC)\n''Temperature@Tp0t - PSU Secondary H/S Diode cooked temp (DegC)\n''Temperature@TPCD - PCH Die cooked temp (DegC)' )

# --- Voltage --- #
sensorarray3=( 'Voltage@VC0C - CPU Core low-side voltage\n''Voltage@VC0S - CPU VSA low-side voltage\n''Voltage@VCTR - CPU Riser 12V high-side voltage\n''Voltage@VD2R - Power Supply 12V voltage\n''Voltage@VG0C - GFX-A Core low-side voltage\n''Voltage@VG0R - GFX-A Riser 12V high-side voltage\n''Voltage@VG0S - GFX-A VDDCI low-side voltage\n''Voltage@VG1C - GFX-B Core low-side voltage\n''Voltage@VG1R - GFX-B Riser 12V high-side voltage\n''Voltage@VG1S - GFX-B VDDCI low-side voltage\n''Voltage@VH0R - SSD 3V3 low-side voltage\n''Voltage@VI1R - I/O Riser 11V high-side voltage' )


# --- Airport --- #
if [ $testname == "Airport" ] || [ $testname == "airport" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MAC Address Verification Test\n"
		echo "Verifies the AirPort MAC Address is not all 00's or all FF's."
		echo "What this is checking for is if the MAC Address has been properly addressed in the system."
		echo "If this fails, it could mean that the PCI BUS does not read the BroadCom chip, which may mean that there is either damage to the X51 card, or port damage on the connector."
		no_param

	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Power Cycle Test\n"
		echo -e "This test performs a quick Off/On cycle and then runs a quick wireless scan to determine that the Airport is functioning.\n"
		echo -e "If this tests errors, then there is a chance that wireless network was not created, or the airport is not on."
		echo "The network will now be setup. It will report an error if there is already an existing network location named 'Wi-Fi'."
		sleep 1
		echo
		/usr/sbin/networksetup -createnetworkservice "Wi-Fi" "Wi-Fi"
		echo "Network setup completed."
		echo "To check if the network is on, go to System Prefernces > Network and then select 'Wi-Fi' and 'Turn Wi-Fi On'."
		echo "Exiting."
		sleep 5
		setup_confirmation
	
	elif [ $testid == "8" ]; then
		echo 
		echo -e "You have selected "$testname":"$testid": PCI ID Register Verification Test\n"
		echo "This test double-checks the PCI Identification registers to ensure that during a reboot, or before the last probe, the register locations have not changed."
		echo "If this test fails, it may mean there is worse problem than having a bad airport, so be sure to check all devices in System Profiler, specifically the USB and Thunderbolt Ports."
		echo "If you are missing any of these ports then there is a good chance that caused this test failure. Otherwise, treat this like it has a failing BroadCom Chip/X51 Card."
		no_param
		
	elif [ $testid == "9" ]; then
		echo 
		echo -e "You have selected "$testname":"$testid": PCI Root Port ID Register Verification Test\n"
		echo -e "This test just double-checks the register to ensure is has no errors in it.\n" 
		echo -e "It differentiates from test 8 by looking for errors within the register and not just an error with the registers themselves."
		no_param
		
	elif [ $testid == "15" ]; then
		echo 
		echo -e "You have selected "$testname":"$testid": BCM4360 PLL Lock Test\n"
		echo "This test is an internal test to the BroadCom chip itself, if it fails, focus on just that card."
		no_param
		
	elif [ $testid == "41" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Wake on Wireless; Internal Simulation Test\n"
		echo -e "This test checks to make sure the System Management Controller (SMC) can properly communicate to the BroadCom chip to wake it up.\n"
		echo -e "The test puts the system to sleep and uses the Real-Time Clock (RTC) to wake it up in 60 seconds. If the clock fails to wake it up, or if the BroadCom chip fails to receive the wake signal, there is a default 240 second run-time for the test that will auto-wake the system.\n"
		echo -e "This test can fail due to external devices being plugged in, or being used. For example, if you have a mouse/keyboard plugged in, moving the mouse or hitting any key on the keyboard will wake the system and cause a false-fail. This also applies to plugging in a monitor or USB Device and Thunderbolt devices.\n"
		no_param

	elif [ $testid == "47" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sleep/Wake PCI Error Count Screen Test\n"
		echo -e "This test puts the system to sleep and once it wakes, it checks to see how many PCIe Devices errors and Bridge errors occur. If either count is under 50, the system passes.\n"
		echo "If this test fails, then keep your focus on the BroadCom chip." #Add more in-depth information on enumeration when you learn it!
		no_param

	elif [ $testid == "48" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Wake on Wireless Internal Simulation (StandBy) Test\n"
		echo -e "This test functions very similarly to how test 41 does, but it's main difference is what power state the system is in. When the system goes to sleep in this state, a lot of system caches and contexts (CPU, Memory, and Chipset) are dumped. When this happens, the system 'loses' its buffers and allows for a more 'refreshed' wake-up.\n"
		echo "If the system fails to wake, yet the power button glows solid, it could mean your Chipset failed to re-initialize certain parts of your system, or it could mean your Memory did not reboot properly. This is a very complex process, so just know that there are some factors which are unknown." 
		no_param

	elif [ $testid == "131" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": HDMI WiFi Noise-Floor Test\n"
		echo "This test requires the HDMI-GEFEN to be connected to the HDMI port, and for the test to be done within the Wireless Chamber."
		echo "This test works by sending a signal down the HDMI-GEFEN connection in an attempt to fill the chamber with excessive, unwanted singals, then as the test starts, the unit tries to filter out the excess noise and only finds the desired signal."
		no_param

	elif [ $testid == "112" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": USB3 WiFi Noise-Floor Test\n"
		echo "This test requires the SLB-USB to be connected to both the Top-Right and Top-Left USB Ports, and for the test to be done within the Wireless Chamber."
		echo "This test works by sending a signal down the USBs' connection in an attempt to fill the chamber with excessive, unwanted singals, then as test starts, the unit tries to filter out the excess noise and only finds the desired signal."
		no_param

	elif [ $testid == "122" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt WiFi Noise-Floor Test Test\n"
		echo "This test requies a Thunderbolt Loopback cable to connected to the Top-Left and Middle-Right ports, and for the test to be done within the Wireless Chamber."
		echo "This test works by sending a signal down the Thunderbolt connection in an attempt to fill the chamber with excessive, unwanted singals, then as test starts, the unit tries to filter out the excess noise and only finds the desired signal."
		no_param

	elif [ $testid == "155" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Chamber Performance Test\n"
		echo "This test requires the unit to be attached to a Wireless server and to be in a Wireless Chamber."
		no_param

	else
		no_test

	fi
fi

# --- AudioController --- #

if [ $testname == "AudioController" ] || [ $testname == "audiocontroller" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Device Check Test\n"
		echo "This simply checks to see if the AudioController CODEC is within the IORegistry. It then checks what the registry has against what the system probes during boot-up."
		no_param

	else
		no_test
	fi
fi

# --- AudioPort2 --- #
if [ $testname == "AudioPort2" ] || [ $testname == "audioport2" ] || [ $testname == "AudioPort" ] || [ $testname == "audioport" ]; then
	if [ $testid == "2" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify No Connection Test\n"
		echo "Do not have the AudioCable plugged in on the tested port." 
		no_param

	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": THD+N Test\n"
		echo "This test requires that you have an ADA Box plugged in and that you use the Analog cable."
		echo "Total Harmonic Distortion + Noise (THD+N) is a measurement of distortion present within a signal. If this test fails, you could have a few issues at hand; improper electromagnetic interference (EMI) setup, bad noise filtering or ground, or a bad transmitter/receiver." 
		echo "Check the output device for any damages and then check the input devices for any as well."
		no_param

	elif [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SNR Test\n"
		echo "This test requires that you have an ADA Box plugged in and that you use the Analog cable."
		echo "Signal-to-Noise Ratio (SNR) is, by definition, a measurement used to compare the levels of a desired signal to the level of background noise. What this means, is that while the ADA Box is sending the data to the UUT, it is also looking for any stray signals and measuring them in decibels (dB)."
		no_param
		
	elif [ $testid == "6" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Channel Seperation Test\n"
		echo "This test requires that you have an ADA Box plugged in and that you use the Analog cable."
		echo "As the name of the test implies, this is a test which does just that; it sends a signal down both the Left and Right channels of the Headphone Jack and measures the difference between the two."
		no_param
		
	elif [ $testid == "7" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Digital Pattern - Quick Digital Test\n"
		echo "This test requires that you have an ADA Box plugged in and that you use the Analog cable."
		echo "This test, as the name implies, is just a quick digital pattern test. It sends a predetermined frequency down the optical cable and measures how much loss occured on the signal's short trip."
		no_param
		
	else
		no_test
	fi
fi

# --- AudioSystem --- #
if [ $testname == "AudioSystem" ] || [ $testname == "audiosystem" ]; then
	if [ $testid == "21" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Auto-Mic Binary Tones Test\n"
		echo "This test requires there there be an external mic plugged into the unit and that the speaker functions properly."
		echo "In short, this test outputs a static pulse via the speaker which the USB Mic hears, analyzes, and measures to ensure proper use from the Mic Codec." 
		no_param
		
	else
		no_test

	fi
fi
# --- Bluetooth --- #
if [ $testname == "Bluetooth" ] || [ $testname == "bluetooth" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": USB Interface Test\n"
		echo "This test simply checks the registry to see if there are any USB devices plugged in to port that is designated. If it finds a populated port on the tested location, it passes. Otherwise, it will fail."
		no_param

	elif [ $testid == "55" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": HDMI Bluetooth Noise Floor Test\n"
		echo "This test requires the HDMI-GEFEN to be connected to the HDMI port, and for the test to be done within the Wireless Chamber."
		echo "This test works by sending a signal down the HDMI-GEFEN connection in an attempt to fill the chamber with excessive, unwanted singals, then as the test starts, the unit tries to filter out the excess noise and only finds the desired signal."
		no_param

	elif [ $testid == "254" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": WiFi/Bluetooth Isolation Test\n"
		echo "This test determines if the Wi-Fi Signal will interfere with the Bluetooth functionality."
		echo "In the event of a failure, this is strictly limited to the X51."
		no_param

	elif [ $testid == "300" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Wake on Bluetooth - Internal Simulation; Standby Test\n"
		echo "The names implies the functionality of this test. The system is put in to a low-power sleep state, typically G3, where all of the peripherals are turned off. This means that the keyboard, mouse, and monitor plug-ins will not power the system on."
		echo "Only a signal from Wi-Fi or Bluetooth will wake the system up in this sleeping state, so for this test, the Bluetooth is used."
		no_param

	elif [ $testid == "301" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Wake on Bluetooth - Internal Simulation; G3 Standby Test\n"
		echo "The names implies the functionality of this test. The system is put in to a low-power sleep state, typically G3, where all of the peripherals are turned off. This means that the keyboard, mouse, and monitor plug-ins will not power the system on."
		echo "Only a signal from Wi-Fi or Bluetooth will wake the system up in this sleeping state, so for this test, the Bluetooth is used."
		no_param

	elif [ $testid == "451" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Bluetooth Performance Test\n"
		echo "This test is a standard signal integrity test for Bluetooth. It is necessary to perform this test within a Wireless Chamber to truly test the performance."
		echo "If this test is to fail, it is due to issue with either the X51 or Wi-Fi Antenna."
		no_param
		
	else
		no_test
		
	fi
fi

# --- BootROM --- #
if [ $testname == "BootROM" ] || [ $testname == "bootrom" ] || [ $testname == "bootROM" ]; then
	if [ $testid == "2" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": BootROM FW GUID MAC Addr. Checksum Test\n"
		echo "This test takes the Firmware Graphical User Identification (GUID) MAC Address and does a checksum to see if the BootROM Firmware is not corrupted."
		no_param

	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": BootROM Locked Verification Test\n"
		echo "This test takes a known, predetermined checksum value of a locked bootROM and compares it to the system's current bootROM checksum to ensure they match up with a 'Locked' version of the bootROM."
		no_param

	elif [ $testid == "7" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": HSW Top Swap Disabled Check Test\n"
		echo "I really don't know what this is, or does, so whatever. It's the bootROM."
		no_param
		
	else
		no_test
		
	fi
fi

# --- Chipset --- #
if [ $testname == "Chipset" ] || [ $testname == "chipset" ]; then
	if [ $testid == "25" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DMI Error Check Test\n"
		echo "This test requires Product 387 to be run before it."
		echo "The Direct Media Interface (DMI) is a straight connection from the Chipset (PCH) to the Processor."
		echo "This test sends data through this bus via the VertexPerformance benchmark and then lists all of the errors that are found."
		sleep 2
		no_param

	elif [ $testid == "50" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Chipset DMI Error Counters Test\n"
		echo "This test requires Product 387 to be run before it."
		echo "The Direct Media Interface (DMI) is a straight connection from the Chipset (PCH) to the Processor."
		echo "This test sends data through this bus via the VertexPerformance benchmark and then lists a count of all the errors that are found."
		sleep 2
		no_param
		
	elif [ $testid == "51" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PEG Error Counter Test\n"
		echo "This test requires Product 387 to be run before it. This test also requires specific NVRAM settings to be enabled before running."
		echo "Fetching NVRAM script..."
		sleep 2
		echo "Starting!"
		sleep 1
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_51_52.command
		#no_param
		exit 0;
		
	elif [ $testid == "52" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PCIe Error Counter Test\n"
		echo "This test requires Product 387 to be run before it. This test also requires specific NVRAM settings to be enabled before running."
		echo "Fetching NVRAM script..."
		sleep 2
		echo "Starting!"
		sleep 1
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_51_52.command
		#no_param
		exit 0;
		
	elif [ $testid == "501" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT PLX PCIe Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;
		
	elif [ $testid == "502" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT GFXA PCIe Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;
		
	elif [ $testid == "503" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT GFXB PCIe Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;

	elif [ $testid == "504" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT DMI CTLE Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;
		
	elif [ $testid == "505" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT PLX PCIe CTLE Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;
		
	elif [ $testid == "506" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT GFXA PCIe CTLE Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;
	
	elif [ $testid == "507" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IVT GFXB PCIe CTLE Margining Test\n"
		echo "This test requires specific NVRAM settings."
		echo "Fetching NVRAM script..."
		/Volumes/Debug_Test_Setup/DebugSetup/Chipset/Setup_Chipset_501-507.command
		exit 0;
				
	else
		no_test
		
	fi
fi

# --- EthernetController --- #
if [ $testname == "EthernetController" ] || [ $testname == "ethernetcontroller" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MAC Address Verification Test\n"
		echo "This test verifies that the MAC address exists for the selected Ethernet controller; En0 and En1."
		no_param

	elif [ $testid == "10" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MAC Loopback Test\n"
		echo "This test verifies that there is no mismatch between data and looped back within the MAC controller."
		no_param
		
	elif [ $testid == "11" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PHY 1000 Loopback Test\n"
		echo "This test verifies that there is no mismatch between data sent and looped back via the physical (PHY) layer at 1000 Mbps."
		no_param
	
	elif [ $testid == "12" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PHY 100 Loopback Test\n"
		echo "This test verifies that there is no mismatch between data sent and looped back via the physical (PHY) layer at 100 Mbps."
		no_param
		
	elif [ $testid == "13" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PHY 10 Loopback Test\n"
		echo "This test verifies that there is no mismatch between data sent and looped back via the physical (PHY) layer at 10 Mbps."
		no_param
		
	elif [ $testid == "20" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Jumbo Packet PHY Loopback Test\n"
		echo "This test verifies that there is no mismatch between data sent and looped back in a jumbo packet via the physical (PHY) layer at the highest supported speed."
		no_param
		
	elif [ $testid == "22" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Auto Wake on LAN Test\n"
		echo "This test verifies that the system can wake from sleep with a Wake On LAN (WOL) packet."
		echo "This test still requires a physical link to the system; any damage to the connecting cables could easily be the cause of failures."
		no_param
		
	else 
		no_test
		
	fi
fi


# --- EthernetPort --- #
if [ $testname == "EthernetPort" ] || [ $testname == "ethernetport" ]; then
	if [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": 100 BaseT Half-Duplex Ping Test\n"
		echo "This test requires a connection to the IP: 10.0.0.5. This can be done during the start of PreBurn or during the manual Flash setup."
		echo "If you have no access to the PI Server to run this test, please contact a Test Engineer for setup assistance."
		no_param

	elif [ $testid == "5" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": 1000 BaseT Full-Duplex Ping Test\n"
		echo "This test requires a connection to the IP: 10.0.0.5. This can be done during the start of PreBurn or during the manual Flash setup."
		echo "If you have no access to the PI Server to run this test, please contact a Test Engineer for setup assistance."
		no_param
		
	elif [ $testid == "13" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": 8% Margin Loopback EtherPerf Test\n"
		echo "This test requires a requires an ethernet loopback to be connected between ETH0 and ETH1 before running."
		no_param
		
	elif [ $testid == "30" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Ethernet Present Test\n"
		echo "This test requires an ethernet cable to be plugged into the port associated with the to-be-run test."
		no_param
		
	elif [ $testid == "31" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Ethernet Not Present Test\n"
		echo "This test requires an ethernet cable to not beplugged into the port associated with the to-be-run test."
		no_param
		
	else
		no_test
	fi
fi
		
# --- HardDrive --- #
if [ $testname == "HardDrive" ] || [ $testname == "harddrive" ]; then
	if [ $testid == "5" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Check SMART Status Test\n"
		no_param

	elif [ $testid == "6" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Check SMART Attributes Test\n"
		no_param		
		
	elif [ $testid == "17" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SSD Extended Write Test\n"
		no_param		
		
	elif [ $testid == "25" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": OOB Connectivity Test\n"
		no_param		
		
	elif [ $testid == "27" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SSD EEPROM Revision Check Test\n"
		no_param		
		
	elif [ $testid == "30" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Targeted Read Scan Test\n"
		echo "This test requires Product 388 to be ran before running, and then Product 389 to be run after."
		no_param			
		
	else
		no_test
	fi
fi

# --- LED --- #
if [ $testname == "LED" ] || [ $testname == "led" ]; then
	if [ $testid == "20" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": IOL On Test\n"
		no_param

	else
		no_test
		
	fi
fi

# --- Memory --- #
if [ $testname == "Memory" ] || [ $testname == "memory" ]; then
	if [ $testid == "5" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Check for ECC Errors Test\n"
		no_param

	elif [ $testid == "15" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Main Memory Vendor Check Test\n"
		no_param	
	
	elif [ $testid == "50" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Hardware Engine Setup Part 1 Test\n"
		echo -e "This test requires that you restart the unit after running the test, then running Hardware Engine Results Test (Memory 51)."
		no_param		
		
	elif [ $testid == "51" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Hardware Engine Results Test\n"
		echo "This test requires that you run at least one of the tree Hardware Engine Setup Tests. (Memory 50, 52, and 53)."
		no_param
	
	elif [ $testid == "52" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Hardware Engine Setup Part 2 Test\n"
		echo "This test requires that you restart the unit after running the test, then running Hardware Engine Results Test (Memory 51)."
		no_param
		
	elif [ $testid == "53" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Hardware Engine Setup Part 3 Test\n"
		echo "This test requires that you restart the unit after running the test, then running Hardware Engine Results Test (Memory 51)."
		no_param
			
	elif [ $testid == "60" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Block Checkerboard Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script?"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
		
	elif [ $testid == "61" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Bit Checkboard Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script?"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
		
	elif [ $testid == "62" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Sequential Byte Block Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script?"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
		
	elif [ $testid == "63" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Walking Ones Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script?"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
		
	elif [ $testid == "64" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Walking Zeros Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script?"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
		
	elif [ $testid == "65" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Walking Spread Bits Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script? (Y/N)"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
		
	elif [ $testid == "66" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": MP Walking Bit Flip Test\n"
		sleep 1
		echo -e "Do you wish to run the Memory Parse script?"
		read memory1
			if [ $memory1 == "Y" ] || [ $memory1 == "y" ]; then
			echo "Running MemScript.nsh, this may take some time."
			/Volumes/Debug_Test_Setup/Mem_Test_Parse/MemScript.nsh
			
			elif [ $memory1 == "N" ] || [ $memory1 == "n" ]; then
			echo
			echo "Very well, returning to top-level..."
			sleep 2
		
			else
			echo "Entered information did not meet internal parameters, please retry."
			setup_confirmation
		
			fi
	fi
fi


# --- Mikey --- #
if [ $testname == "Mikey" ] || [ $testname == "mikey" ]; then
	if [ $testid == "6" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Mikey Button and Line Signal using ADA Test\n"
		echo "This test requires that you have an ADA Box plugged in an that you use the Analog cable." 
		no_param

	else
		no_test
		
	fi
fi

# --- MLB --- #
if [ $testname == "MLB" ] || [ $testname == "mlb" ]; then
	if [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify ICT Was Run and Passed Test\n"
		no_param
	
	elif [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify FCT Was Run and Passed Test\n"
		no_param

	elif [ $testid == "8" ]; then
		echo
		echo "You have selected "$testname":"$testid": Verify MLB Serial Number Checksum Test\n"
		echo "This test checks if the system's serial number is written to the MLB."
		no_param
	
	else
		no_test
	fi
fi

# --- Motor --- #
if [ $testname == "Motor" ] || [ $testname == "motor" ]; then
	if [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Turn On Automatically Test\n"
		no_param
	
	elif [ $testid == "5" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Quick Motor Test\n"
		no_param
		
	elif [ $testid == "21" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify Max Speed Other Fans at Full Test\n"
		no_param
		
	elif [ $testid == "24" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify Fan Stall Recovery Test\n"
		no_param
		
	else
		no_test
	fi
fi

# --- Processor --- #
if [ $testname == "Processor" ] || [ $testname == "processor" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Whetstone Test\n"
		no_param
	
	elif [ $testid == "2" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Dhrystone Test\n"
		no_param
		
	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Linback Test\n"
		no_param
		
	elif [ $testid == "5" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Encoder Test\n"
		no_param
		
	elif [ $testid == "22" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Validate SMT Mode Test\n"
		no_param
		
	elif [ $testid == "24" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Turbo Mode Register Check Test\n"
		no_param
		
	elif [ $testid == "25" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": AES Functionality Verification Test\n"
		no_param
		
	elif [ $testid == "26" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": AVX Verification Test\n"
		no_param
		
	elif [ $testid == "27" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": VT-d Verification Test\n"
		no_param
		
	elif [ $testid == "29" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Random Number Generator Verification Test\n"
		no_param
		
	elif [ $testid == "30" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": RunIn Processor Voltage and Frequency Test\n"
		no_param
		
	elif [ $testid == "31" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": RunIn Processor Voltage and Frequency Test - Load Mode\n"
		no_param
		
	else 
		no_test
		
	fi
fi

# --- Product --- #
if [ $testname == "Product" ] || [ $testname == "product" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Stress Test\n"
		no_param
	
	elif [ $testid == "2" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Serial Number Format Test\n"
		no_param
		
	elif [ $testid == "11" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": HFS+ Journaled Boot Volume Check Test\n"
		no_param
		
	elif [ $testid == "14" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sleep/Wake 30/60 Test\n"
		no_param
		
	elif [ $testid == "19" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Check, Log, and Reset PCIe Uncorrectable and Correctable Errors Test\n"
		echo "This test requiers the AGC3 NVRAM settings, they will be applied now!"
		/Volumes/Debug_Test_Setup/DebugSetup/NVRAM/Nvram_setup_no_overrides_agc3.sh
		echo "NVRAM setting applied!"
		sleep 2
		echo "The system will reboot in 10 seconds, press CTRL+Z in order to halt the boot, or simply let this finish."
		sleep 10
		reboot
		
	elif [ $testid == "21" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": HFS+ Journaled All Volume Check Test\n"
		no_param
		
	elif [ $testid == "25" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PLX PCIe Switch Tx/Rx Margining Test\n"
		no_param
		
	elif [ $testid == "26" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PLX PCIe Switch Eye Margining Test\n"
		no_param
		
	elif [ $testid == "29" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PSU Throttle Check Test\n"
		no_param
		
	elif [ $testid == "71" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": 300s Transient Power Test\n"
		no_param
		
	elif [ $testid == "72" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": GCON Power On/Off Test\n"
		echo "This test requires the no-overrides AGC3 NVRAM settings, they will be applied now."
		/Volumes/Debug_Test_Setup/DebugSetup/NVRAM/Nvram_setup_no_overrides_agc3.sh
		echo "NVRAM setting applied!"
		sleep 2
		echo "This test also requires that a specific video driver be enabled; OpenGL. Applying it now."
		sleep 2
		/Volumes/Debug_Test_Setup/DebugSetup/graphics/enable_opengl.sh
		echo
		echo "The system will reboot in 10 seconds, press CTRL+Z in order to halt the boot, or simply let this finish."
		sleep 10
		reboot
		
	elif [ $testid == "73" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": GPU Power On/Off Test\n"
		echo "This test requires the no-overrides AGC3 NVRAM settings, they will be applied now."
		/Volumes/Debug_Test_Setup/DebugSetup/NVRAM/Nvram_setup_no_overrides_agc3.sh
		echo "NVRAM settings applied!"
		sleep 2
		echo "This test also requires that a specific video driver be enabled; ATI. Applying it now."
		sleep 2
		/Volumes/Debug_Test_Setup/DebugSetup/graphics/enable_ati.sh
		echo
		echo "The system will reboot in 10 seconds, press CTRL+Z in order to halt the boot, or simply let this finish."
		sleep 10
		reboot
		
	elif [ $testid == "360" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DOE 360 Test\n"
		echo "This test is dedicated to strictly stressing the Memory for 10 minutes."
		no_param
		
	elif [ $testid == "387" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DOE 387 Test\n"
		echo "This test is dedicated to sending data via the PCIe BUS to discover any faults in data-transmission."
		no_param
		
	elif [ $testid == "388" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DOE 388 - Start Test\n"
		echo "This test is dedicated to sending data via the DMI (Direct Media Interface) BUS to discover any faults in data-transmission."
		echo "This test is only run before HardDrive 30."
		no_param
		
	elif [ $testid == "389" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DOE 389 - Stop Test\n"
		echo "This test is dedicated to sending data via the DMI (Direct Media Interface) BUS to discover any faults in data-transmission."
		echo "This test is only run after HardDrive 30."
		no_param
		
	else 
		no_test
		
	fi
fi

# --- RiserCard --- #
if [ $testname == "RiserCard" ] || [ $testname == "Risercard" ] || [ $testname == "risercard" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify ICT Was Run and Passed Test\n"
		no_param
	
	elif [ $testid == "2" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Verify FCT Was Run and Passed Test\n"
		no_param

	elif [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Serial Number Checksum Test\n"
		echo "This test checks if the board's serial number are written to themselves."
		no_param
	
	else
		no_test
	fi
fi

# --- Sensor --- #
if [ $testname == "Sensor" ] || [ $testname == "sensor" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sensor Test\n"
		echo -e "Please select which sensor group you wish to see: Current/Temperature/Voltage"
		read sensortype
		sleep 2 
			if [ $sensortype == "Voltage" ] || [ $sensortype == "voltage" ]; then
				echo
				echo -e "${sensorarray3[@]}"
				no_param


			elif [ $sensortype == "Current" ] || [ $sensortype == "current" ]; then
				echo
				echo -e "${sensorarray1[@]}"
				no_param


			elif [ $sensortype == "Temperature" ] || [ $sensortype == "temperature" ]; then
				echo
				echo -e "${sensorarray2[@]}"
				no_param


			else
				no_test
			fi				

	elif [ $testid == "11" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Extended Flat-Line Sensor Test\n"
		no_param
		
	elif [ $testid == "14" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Accelerometer Self Test\n"
		no_param
		
	elif [ $testid == "30" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sensor Noise Test; 0 Margin\n"
		no_param
	
	elif [ $testid == "34" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sensor Noise Test, 2.0 Margin\n"
		no_param
		
	elif [ $testid == "64" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sensor Noise Test, Background Power Transient\n"
		no_param
		
	elif [ $testid == "76" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Sensor Limit with Load Test\n"
		no_param
		
	else
		no_test
	fi
fi

# --- SMC --- #
if [ $testname == "SMC" ] || [ $testname == "smc" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Critical Sensor Test\n"
		echo "No special parameters are needed to run this test."
		echo "Running 'ypc2' command."
		echo
		/Path/ypc2 -rk SBF
		echo
		echo "Please check the Troubleshooting guide to find which sensors are linked back the recorded failures."
		exit 0;
	
	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Shutdown Cause Check"
		echo -e "If the system has been 'properly' shutdown, as in selecting the Shutdown option"
		echo -e "from the Apple drop down menu, this test will not register a failure. Please reffer to"
		echo -e "the logs for more information."
		sleep 3
		no_param

	elif [ $testid == "6" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": EPM Flash Check Test\n"
		no_param
		
	elif [ $testid == "7" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SMC EPM Flash Check Test\n"
		no_param

	elif [ $testid == "8" ]; then
		echo
		echo "You have selected "$testname":"$testid": Power Balancing Check\n"
		no_param

	elif [ $testid == "9" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": App. Code Mode Check\n"
		no_param
		
	elif [ $testid == "10" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PECI Sensor Check\n"
		no_param
	
	elif [ $testid == "13" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SMC Lock Verification Test\n"
		no_param
	
	elif [ $testid == "14" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": CRC Verification Test\n"
		no_param
		
	elif [ $testid == "15" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PECI Sensor Check\n"
		no_param
		
		
	elif [ $testid == "21" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": FPHT Verification Test\n"
		no_param
	
	elif [ $testid == "23" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": CAT_ERR Detect Test\n"
		echo -e "Running the SMC 23 Debug Script.\n"
		echo "Working..."
		sleep 3
		/Volumes/Debug_Test_Setup/DebugSetup/SMC_23_Debug.sh.command
		sleep 5
		echo "Returning to top-level..."
		setup_confirmation

	elif [ $testid == "24" ]; then
		echo
		echo "This is just a setup test, there is no need to run this."
		no_param
		
	elif [ $testid == "800" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SMC Event Buffer Dump\n"
		no_param
		
	elif [ $testid == "801" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": SMC Crash Event Buffer Dump\n"
		no_param

	else
		no_test
	fi
fi

# --- Speaker --- #
if [ $testname == "Speaker" ] || [ $testname == "speaker" ]; then
	if [ $testid == "26" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Mono Speaker Test\n"
		no_param

	else
		no_test

	fi
fi

# --- ThermalInterface --- #
if [ $testname == "ThermalInterface" ] || [ $testname == "thermalinterface" ] || [ $testname == "thermal" ]; then
	if [ $testid == "75" ]; then
		echo 
		echo -e "You have selected "$testname":"$testid": Thermal Interface 75 Test\n"
		echo "This test requires one setup script to run before the testing begins."
		echo "This test aslo requires specific NVRAM settings to be applied, so they will be applied now."
		/Volumes/Debug_Test_Setup/DebugSetup/Thermal/Setup_Thermal.command
		sleep 2
		echo
		echo "The system will reboot in 10 seconds, press CTRL+Z in order to halt the boot, or simply let this finish."
		sleep 10
		reboot
		
	else 
		no_test

	fi
fi

# --- Thunderbolt --- #
if [ $testname == "Thunderbolt" ] || [ $testname == "thunderbolt" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt PCI Interface Test\n"
		no_param

	elif [ $testid == "2" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt Sleep/Wake Test\n"
		no_param
	
	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt Error Register Check Test\n"
		no_param
		
	elif [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt Internal Loopback Test\n"
		no_param
		
	elif [ $testid == "21" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Read PCIe Link Error Registers Test\n"
		no_param
		
	elif [ $testid == "30" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt PCIe Gen2 Link Width Verification Test\n"
		no_param	
	
	elif [ $testid == "31" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt PCIe Gen2 Link Speed Verification Test\n"
		no_param
		
	elif [ $testid == "40" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Thunderbolt Power Off Verification Test\n"
		no_param
		
	else 
		no_test

	fi
fi
		
# --- ThunderboltPort --- #
if [ $testname == "ThunderboltPort" ] || [ $testname == "thunderboltport" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": ThunderboltPort Interface Test\n"
		no_param

	elif [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": ThunderboltPort External Loopback Test\n"
		no_param

	elif [ $testid == "4" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": ThunderboltPort Dual Like Verification Test\n"
		no_param

	elif [ $testid == "22" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": 10 Secs Low Amplitude PRBS Bit Error Rate Test\n"
		no_param

	elif [ $testid == "64" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": ThunderboltPort Ethernet Loopback Test\n"
		no_param

	else 
		no_test

	fi
fi

# --- USBController --- #
if [ $testname == "USBController" ] || [ $testname == "usbcontroller" ]; then
	if [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": USB XHCI Interface Test\n"
		no_param

	else
		no_test

	fi
fi		

# --- USBPort --- #
if [ $testname == "USBPort" ] || [ $testname == "usbport" ]; then
	if [ $testid == "3" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": USB Device Pressence Test\n"
		no_param

	elif [ $testid == "32" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": USB High Speed Device Pressence Test\n"
		no_param

	elif [ $testid == "130" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": USB3 HUB and USB3 Drive with 2M Cable Pressence Extended Test\n"
		echo -e "This test requires that a USB3.0 device, named 'USB3MEDIA', be plugged in to a USB HUB, then have that HUB connected to the system through a 2M USB extender cable."
		startup

	else
		no_test

	fi
fi		

# --- VideoController --- #
if [ $testname == "VideoController" ] || [ $testname == "videocontroller" ]; then
	if [ $testid == "55" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": GPU VRAM Combination Check Test\n"
		no_param
		
	elif [ $testid == "1" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Run all the OpenGL Tests\n"
		echo "This test requires the no-overrides AGC3 NVRAM settings, they will be applied now."
		/Volumes/Debug_Test_Setup/DebugSetup/VideoController/Setup_VideoController_1_70_71.command 
		
	elif [ $testid == "53" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Graphics Power Transition Test: 10 minutes Test\n"
		echo "This test requires the no-overrides AGC3 NVRAM settings, they will be applied now."
		/Volumes/Debug_Test_Setup/DebugSetup/VideoController/Setup_VideoController_1_70_71.command 
		
	elif [ $testid == "70" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Fragment Instruction Test\n"
		no_param
		
	elif [ $testid == "71" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": Vertex Instruction Test\n"
		no_param	

	elif [ $testid == "94" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": PCIe 16-Link Width Verification Test\n"
		no_param
		
	elif [ $testid == "171" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DG100 Frame Buffer Address as Data Test\n"
		no_param
		
	elif [ $testid == "172" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DG101 Frame Buffer Pattern Test\n"
		no_param
		
	elif [ $testid == "173" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DG102 Frame Buffer Marching 1's and 0's Test\n"
		no_param
		
	elif [ $testid == "174" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DG103 Frame Buffer Knaizi Hartman Test\n"
		no_param
		
	elif [ $testid == "175" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DG104 Frame Buffer MOD3 Test\n"
		no_param
		
	elif [ $testid == "539" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": RunIn AMD/ATI Graphics Suite for Tahiti Cards Test\n"
		no_param
		
	elif [ $testid == "560" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": AMD/ATI Memory Over Current for Tahiti/Pitcairn Cards Test\n"
		no_param
		
	elif [ $testid == "185" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": RunIn AMD/ATI DVO Graphics Suite for Tahiti/Pitcairn Cards Test\n"
		no_param
		
	elif [ $testid == "186" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": RunIn AMD/ATI DVO Graphics Suite for Tahiti/Pitcairn Cards Test\n"
		no_param	
	
	else
		no_test

	fi
fi

# --- VideoPort2 --- #
if [ $testname == "VideoPort2" ] || [ $testname == "videoport2" ] || [ $testname == "videoport" ]; then
	if [ $testid == "220" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": HDMI ROM Adapter Test\n"
		echo "This test requires a DVI-HDMI connection to be run correctly."
		no_param

	elif [ $testid == "225" ]; then
		echo
		echo -e "You have selected "$testname":"$testid": DAVDP 4k High-Resolution Video Patter Test with MST\n"
		echo "This test requires a DAVDP Box and that no other display device to be connected on the same Thunderbolt Falcon Ridge location."
		echo "This means that if you failed Top-Right, you can not have the main display connected to Mid-Right while running this test. It will fail."
		echo "This test also requires that the DAVDP Ethernet be connected to the LEFT Ethernet Port."
		no_param

	else
		no_test

	fi
fi

echo "You did something wrong...please retry."
setup_confirmation
	}
	
#---------------------#
# EFI Hang Test Setup #
#---------------------#

efi_test_setup()
	{
	echo "EFI tests require specific NVRAM settings to be applied, fetching NVRAM settings..."
	sleep 1
	/Volumes/Debug_Test_Setup/DebugSetup/NVRAM/Nvram_setup_overrides.sh
	echo "NVRAM setting applied!"
	sleep 2
	echo "The system will reboot in 10 seconds, press CTRL+Z in order to halt the boot, or simply let this finish."
	sleep 10
	reboot
	}		

#---------------#
# OS Hang Setup #
#---------------#
os_hang_setup()
	{
	echo
	echo "Since the nature of Hangs is very erratic, there are a limited number of available tests that are allowed to be utilized."
	echo "Please list which TestPackage you would like to  "  

	}


#----------#
# CopyLogs #
#----------#

copylogs()
	{
	echo "/Path/COPYLOGS.pl"
	}

#------------------------------------------------#
# Variables: Tables, User Input, Generic Naming. #
#------------------------------------------------#
# os_testname - May not need					 #
# efi_testname - May not need					 #
# os_test_setup									 #
# os_hang_setup									 #
# efi_test_setup								 #
# os_test 										 #
# efi_test 										 #
# copylogs 										 #
# testid 										 #
# testname 										 #
# setup_confirmation 							 #	
# no_param 										 #
# no_test										 #		
# startup 										 #
# os_tests_avail								 #
# efi_test_avail								 # 
# os_hang_avail 								 #
# efi_hang_avail								 #
# help1											 #
#------------------------------------------------#
startup()
	{
echo 
echo -e "\033[1m-----------------------------------------------------------------------\033[0m"
echo -e "\033[1m				Welcome!\033[0m"
echo -e "\033[1mThis will help you setup the proper testing parameters for use in iTest!\033[0m"
echo 
echo -e "\033[1m-----------------------------------------------------------------------\033[0m"
echo
sleep 3
setup_confirmation
	}

#----------------------------------------------------#
# Help! Original 'Help' command is reserved for BASH #
#----------------------------------------------------#

help1()
	{
	echo -e '\033[1m-----------------------------------------------------------------------\033[0m'
	echo
	echo -e "\033[1mThank you for selecting Help. If you would like to know which OS Tests are available, please type ' OS '. If you would like to know which Hang Tests are available, please type ' Hang '. If you would like to exit this menu, please type ' Exit '.\033[0m"
	read testhelp
	echo -e '\033[1m-----------------------------------------------------------------------\033[0m'
	echo -e "You selected \033[1m"$testhelp".\033[0m"
	
if [ "$testhelp" == "OS" ] || [ "$testhelp" == "os" ]; then
	os_tests_avail
	sleep 2
elif [ "$testhelp" == "Hang" ] || [ "$testhelp" == "hang" ]; then
	echo
	echo "Did the hang occur in EFI? (Y/N)"
	read reply1
	if [ "$reply1" == "y" ] || [ "$reply1" == "Y" ]; then
	echo
		efi_hang_avail
	elif [ "$reply1" == "n" ] || [ "$reply1" == "N" ]; then
	echo
		os_hang_avail
	fi
elif [ "$testhelp" == "Exit" ] || [ "$testhelp" == "exit" ]; then
	echo "Exiting help and starting over..."
	setup_confirmation
fi
	}

os_tests_avail()
	{	
os_tests_available=( 'Airport\n''AudioController\n''AudioPort2\n''AudioSystem\n''BootROM\n''EthernetPort\n''HardDrive\n''LED\n''Mikey\n''MLB\n''Motor\n''Processor\n''Product\n''RiserCard\n''Sensor - Please refer to the Sensor:1 test setup to view the available sensor types.\n''SMC\n''Speaker\n''ThunderboltPort\n''Thermal Interface\n''USBController\n''USBPort\n''VideoController\n''VideoPort2\n' )
	echo
	echo "Available Test Package inputs:"
	echo
	echo -e ${os_tests_available[@]}
	sleep 10
	setup_confirmation
	}

os_hang_avail()
	{	
# Need to add RunIn stuffs.
os_hang_available=( 'Airport\n''Bluetooth\n''HardDrive\n''Memory\n''Processor\n''Sensor - Please refer to the Sensor:1 test setup to view the available sensor types.\n''Thermal Interface\n''Thunderbolt\n''VideoController\n''VideoPort2\n' )
	echo
	echo "Available Hang inputs:"
	echo -e ${os_hang_available[@]}
	sleep 10
	setup_confirmation
	}

efi_test_avail()
	{
efi_test_available=( )
	echo
	echo "Available EFI Test inputs:"
	echo "Note: EFI Tests may not be run outside of RunIn. Please, debug this system to your best knowledge and return it to production."
	echo
	echo -e ${efi_test_available[@]}
	sleep 10
	setup_confirmation
	}

efi_hang_avail()
	{	
efi_hang_available=( )
	echo
	echo "Available EFI Hang Test inputs:"
	echo "Note: EFI Tests may not be run outside of RunIn. Please, debug this system to your best knowledge and return it to production." 
	echo
	echo -e ${efi_hang_available[@]}
	sleep 10
	setup_confirmation
	}

#-------------#
# First step! #
#-------------#
startup	