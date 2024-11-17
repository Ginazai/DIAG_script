#!/bin/bash

while [ true ]; do
	#Primer Menu
	printf "\n\nQue informacion deseas solicitar?\n1. Informacion de CPUs\n2. Informacion de memoria\n3. Informacion de discos\n4. Informacion de red\n5. Todo (diagnostico completo)\n0. Salir\n\n"
	read option
	#Segundo Menu (Menu de formato)
	if [[ "$option" =~ ^[1-5]$ ]]; then
		printf "\n\nSelecciona el formato:\n1. Desplegar en pantalla\n2. Guardar en archivo\n3. Desplegar en pantalla y guardar en archivo\n0. Atras\n\n"
		read sec_option
		#Control de opciones
		if [[ "$sec_option" =~ ^[1-3]$  ]]; then
			#Variables de los detalles de hardware
			cpu_details="$(lscpu)"
			mem_details="$(free -h)"
			disk_details="$(lsblk)"
			part_details="$(fdisk -l)"
			net_details="$(nmcli dev show; cat /etc/resolv.conf)"
			pci_details="$(lshw | grep pci | awk 'NR>2{print $1,$2,$3}')"
			usb_details="$(lshw | grep usb)"
			#Variables de informacion del usuario y sistema operativo
			c_date="$(date '+%d-%m-%Y')"
			date_for_name="_$c_date"
			#usr_name="$(w -h | awk '{print $1}')"
			usr_name="$(whoami)"
			os_info="$(sestatus)"
			#Formato de despliegue de la informacion
			cpu_output="#######################################\nInformacion de CPUs:\n#######################################\n$cpu_details"
			mem_output="#######################################\nInformacion de Memoria:\n#######################################\n$mem_details"
			disk_output="#######################################\nInformacion de Discos:\n#######################################\n$disk_details"
			part_output="\n#######################################\nDetalles de Particiones:\n#######################################\n$part_details"
			net_output="#######################################\nInformacion de Red:\n#######################################\n$net_details"

			usr_info="#######################################\nDetalles de usuario y OS:\n#######################################\nFecha: $c_date\nUsuario: $usr_name\nInformacion del sistema operativo:\n$os_info\n\n"
			#Controlador de depliegue en pantalla
			if [ "$option" -eq 1 ] && [ "$sec_option" -eq 1 ]; then
				printf "$cpu_output"
			elif [ "$option" -eq 2 ] && [ "$sec_option" -eq 1 ]; then
				printf "$mem_output"
			elif [ "$option" -eq 3 ] && [ "$sec_option" -eq 1 ];then
				printf "$disk_output$part_output"
			elif [ "$option" -eq 4 ] && [ "$sec_option" -eq 1 ]; then
				printf "$net_output"
			elif [ "$option" -eq 5 ] && [ "$sec_option" -eq 1 ]; then
				printf "$cpu_output\n$mem_output\n$net_output\n$disk_output\n$usr_info"
			#Controlador de escritura en archivo
			elif [ "$option" -eq 1 ] && [ "$sec_option" -eq 2 ]; then
				printf "$cpu_output" > DIAG_CPU_$usr_name$date_for_name.txt
			elif [ "$option" -eq 2 ] && [ "$sec_option" -eq 2 ]; then 
				printf "$mem_output" > DIAG_MEM_$usr_name$date_for_name.txt
			elif [ "$option" -eq 3 ] && [ "$sec_option" -eq 2 ]; then 
				printf "$disk_output" > DIAG_DSK_$usr_name$date_for_name.txt
				printf "$part_output" >> DIAG_DSK_$usr_name$date_for_name.txt
			elif [ "$option" -eq 4 ] && [ "$sec_option" -eq 2 ]; then 
				printf "$net_output" > DIAG_NET_$usr_name$date_for_name.txt
			elif [ "$option" -eq 5 ] && [ "$sec_option" -eq 2 ]; then 
				printf "$cpu_output\n$mem_output\n$net_output\n$disk_output\n$usr_info" > DIAG_ALL_$usr_name$date_for_name.txt
			#Controlador de despliegue y Escritura
			elif [ "$option" -eq 1 ] && [ "$sec_option" -eq 3 ]; then
				printf "$cpu_output"
				printf "$cpu_output" > DIAG_CPU_$usr_name$date_for_name.txt
			elif [ "$option" -eq 2 ] && [ "$sec_option" -eq 3 ]; then 
				printf "$mem_output"
				printf "$mem_output" > DIAG_MEM_$usr_name$date_for_name.txt
			elif [ "$option" -eq 3 ] && [ "$sec_option" -eq 3 ]; then 
				printf "$disk_output$part_output"
				printf "$disk_output" > DIAG_DSK_$usr_name$date_for_name.txt
				printf "$part_output" >> DIAG_DSK_$usr_name$date_for_name.txt
			elif [ "$option" -eq 4 ] && [ "$sec_option" -eq 3 ]; then
				printf "$net_output" 
				printf "$net_output" > DIAG_NET_$usr_name$date_for_name.txt
			elif [ "$option" -eq 5 ] && [ "$sec_option" -eq 3 ]; then 
				printf "$cpu_output\n$mem_output\n$net_output\n$disk_output\n$usr_info"
				printf "$cpu_output\n$mem_output\n$net_output\n$disk_output\n$part_output\n$usr_info" > DIAG_ALL_$usr_name$date_for_name.txt
			fi
		elif [[ "$sec_option" =~ ^[0-9]+$ ]] && [ "$sec_option" -eq 0 ]; then
		printf "\n\n<< Volviendo al menu principal\n\n"
		else
		printf "\n\nOpcion no reconocida. Intente nuevamente!\n\n"
		fi
	elif [[ "$option" =~ ^[0-9]+$ ]] && [ "$option" -eq 0 ]; then
	printf "\n\nAdios! ^^\n\n"
	break
	else
	printf "\n\nOpcion no reconocida. Intente nuevamente!\n\n"
	fi
done